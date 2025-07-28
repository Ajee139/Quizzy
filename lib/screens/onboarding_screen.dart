import 'package:flutter/material.dart';
import 'package:quizz/screens/user_home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quizzy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black)),
       actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.settings), color: Colors.black),
       ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              const Text(
                'Welcome to Quizzy!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your ultimate quiz app for learning and fun.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Text("Choose from a variety of quizzes on different topics and test your knowledge.", maxLines: 2, textAlign: TextAlign.center,),
              ),
              const SizedBox(height: 40),
              MaterialButton(
                height: 50,
                minWidth: 100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.blue,
                
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserHomeScreen()));
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}