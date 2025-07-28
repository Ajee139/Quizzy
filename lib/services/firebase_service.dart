import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> fetchAllQuizzes() async {
    final querySnapshot = await _firestore.collection('quizzes').get();

    List<Quiz> quizzes = querySnapshot.docs.map((doc) {
      return Quiz.fromMap(doc.id, doc.data());
    }).toList();

    return quizzes;
  }
}
