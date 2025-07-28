import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizz/authService/signUp.dart';
import 'package:quizz/screens/admin/home_screen.dart';
import 'package:quizz/screens/user_home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

   
  
     Future<void> checkUserRoleAndNavigate(UserCredential value, BuildContext context) async {
  final user = value.user;
  if (user != null) {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final role = data?['role'];

        if (role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (role == 'user') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserHomeScreen()));
        } else {
          print('Unknown role: $role');
        }
      } else {
        print('No document found for this UID.');
      }
    } catch (e) {
      print('Error fetching user document: $e');
    }
  } else {
    print('User is null.');
  }
}

Future<void> _login() async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  try {
    final value = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful')),
    );

    // ✅ Navigate based on user role
    await checkUserRoleAndNavigate(value, context);

  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login failed: $error')),
    );
  }
}


    return Scaffold(
      appBar: AppBar(
       
        centerTitle: true,
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Add your login form here
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  
                  fillColor: Color.fromARGB(255, 238, 240, 241),
          filled: true,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                   
                  fillColor: Color.fromARGB(255, 238, 240, 241),
          filled: true,
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 50,
                minWidth: 400,
                color: Colors.blueAccent,
                onPressed: _login,
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              TextButton(
          
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}