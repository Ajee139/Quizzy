import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizz/models/quiz_model.dart';
import 'package:quizz/screens/admin/edit_screen.dart';
// Make sure the path is correct

class HomeScreen extends StatelessWidget {
  final CollectionReference quizzesRef = FirebaseFirestore.instance.collection('quizzes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Home')),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizzesRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final quizzes = snapshot.data!.docs.map((doc) {
            return Quiz.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
              return ListTile(
                title: Text(quiz.title),
                subtitle: Text(quiz.description),
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => QuestionForm(
        quizId: quiz.id,
        initialData: {
          'title': quiz.title,
          'description': quiz.description,
          'questions': quiz.questions, // Ensure Quiz.fromMap handles this
        },
      ),
    ),
  );
},

              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuestionForm(), // New quiz creation
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
