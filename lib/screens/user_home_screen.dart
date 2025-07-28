import 'package:flutter/material.dart';
import 'package:quizz/screens/take_quiz.dart';
import '../models/quiz_model.dart';
import '../services/firebase_service.dart';


class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Quiz> _quizzes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    final firebaseService = FirebaseService();
    final fetched = await firebaseService.fetchAllQuizzes();

    setState(() {
      _quizzes = fetched;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quizzes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
             Padding(
               padding: const EdgeInsets.all(20.0),
               child: SearchBar(
                trailing: [

                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 30),
                ],
                hintText: 'Search quizzes',
                  onChanged: (value) {
                   if (value.isEmpty) {
                      _fetchQuizzes(); // Reset to all quizzes if search is empty
                    } else {
                      // Filter quizzes based on search input
                      setState(() {
                        _quizzes = _quizzes.where((quiz) => quiz.title.toLowerCase().contains(value.toLowerCase())).toList();
                      });
                    }
                  }
                ),
             ),
              Expanded(
                child: ListView.builder(
                    itemCount: _quizzes.length,
                    itemBuilder: (_, index) {
                      final quiz = _quizzes[index];
                      return InkWell(
                        onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizAttemptScreen(quiz: quiz),
                                  ),
                                );
                              },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Container(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          quiz.title,
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                                               Text(
                                                                
                                                                quiz.description, maxLines: 2,style: const TextStyle(fontSize: 16, color: Colors.grey)),
                                        const SizedBox(height: 10),
                                    
                                        
                                          
                                          
                                          
                                        
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ),
                        )),
                      );
                    },
                  ),
              ),
            ],
          ),
    );
  }
}
