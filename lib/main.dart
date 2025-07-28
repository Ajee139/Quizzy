import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizz/authService/signUp.dart';
import 'package:quizz/screens/admin/home_screen.dart';
import 'package:quizz/screens/onboarding_screen.dart';
import 'package:quizz/screens/user_home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
     
      home: Signup(),
      debugShowCheckedModeBanner: false,
    );
  }
}
