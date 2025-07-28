import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizAttemptScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizAttemptScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  int currentIndex = 0;
  Map<int, String> userAnswers = {}; // questionIndex -> selectedOption

  void _nextQuestion() {
    if (currentIndex < widget.quiz.questions.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

 void _submitAnswers() {
  int correct = 0;

  for (int i = 0; i < widget.quiz.questions.length; i++) {
    final userAnswer = userAnswers[i]; // selected answer string
    final correctAnswerIndex = widget.quiz.questions[i]['correctAnswerIndex'];
    final correctAnswer = widget.quiz.questions[i]['options'][correctAnswerIndex];

    print('User Answer: $userAnswer, Correct Answer: $correctAnswer');

    if (userAnswer == correctAnswer) {
      correct++;
    }
  }

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Quiz Completed'),
      content: Text('You got $correct out of ${widget.quiz.questions.length} correct.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // go back to home
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentIndex];
    final selected = userAnswers[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Question ${currentIndex + 1} of ${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
          Text(
  question['question'], // ✅ correct key from your JSON
  style: const TextStyle(fontSize: 16),
),

            const SizedBox(height: 20),
            ...question['options'].map((option) => RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selected,
                  onChanged: (value) {
                    setState(() {
                      userAnswers[currentIndex] = value!;
                    });
                  },
                )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    child: const Text('Previous'),
                  ),
                if (currentIndex < widget.quiz.questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Next'),
                  ),
                if (currentIndex == widget.quiz.questions.length - 1)
                  ElevatedButton(
                    onPressed: _submitAnswers,
                    child: const Text('Submit'),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
