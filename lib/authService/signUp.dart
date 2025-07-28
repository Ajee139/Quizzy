import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizz/authService/login.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController(); 
  bool isLoading = false;

  Future<void> _signUp() async {
    if(userNameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'))
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
   try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailController.text,
    password: passwordController.text,
  );
  final user = credential.user;
  await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'username': userNameController.text,
    'email': emailController.text,
    "role": "user",
  });
  ScaffoldMessenger(child: const SnackBar(content: Text('User created successfully')));

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Login()),
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weak Password'),
        content: const Text('The password provided is too weak.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Already in Use'),
        content: const Text('The account already exists for that email.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
  } 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false ,
        centerTitle: true,
        title: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(labelText: 'Username',
border: OutlineInputBorder(),
fillColor: Color.fromARGB(255, 238, 240, 241),
filled: true,
              )
                ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'
                ,
                border: OutlineInputBorder(),
                
                fillColor: Color.fromARGB(255, 238, 240, 241),
filled: true,
),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password',
                border: OutlineInputBorder(),
                fillColor: Color.fromARGB(255, 238, 240, 241),
filled: true,),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                minWidth: 400,
                color: Colors.blueAccent,
                onPressed: () {
                  _signUp();
                  // Handle sign up logic
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}