import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<QuestionForm> _questions = [QuestionForm()];

  void _addAnotherQuestion() {
    setState(() {
      _questions.add(QuestionForm());
    });
  }

  void _saveQuiz() async {
    if (_formKey.currentState!.validate()) {
      final quizId = const Uuid().v4();
      final List<Map<String, dynamic>> questionsData = [];

      for (var questionForm in _questions) {
        questionsData.add({
          'question': questionForm.questionController.text,
          'options': [
            questionForm.option1Controller.text,
            questionForm.option2Controller.text,
            questionForm.option3Controller.text,
            questionForm.option4Controller.text,
          ],
          'correctAnswerIndex': questionForm.correctAnswerIndex,
        });
      }

      await FirebaseFirestore.instance.collection('quizzes').doc(quizId).set({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'questions': questionsData,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz successfully added!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var questionForm in _questions) {
      questionForm.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Quiz Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Quiz Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Questions:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ..._questions.map((q) => q.build(context)).toList(),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _addAnotherQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Another Question'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuiz,
                child: const Text('Save Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionForm {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();
  int correctAnswerIndex = 0;

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        TextFormField(
          controller: questionController,
          decoration: const InputDecoration(labelText: 'Question'),
          validator: (value) =>
              value!.isEmpty ? 'Enter a question' : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: option1Controller,
          decoration: const InputDecoration(labelText: 'Option 1'),
          validator: (value) =>
              value!.isEmpty ? 'Enter option 1' : null,
        ),
        TextFormField(
          controller: option2Controller,
          decoration: const InputDecoration(labelText: 'Option 2'),
          validator: (value) =>
              value!.isEmpty ? 'Enter option 2' : null,
        ),
        TextFormField(
          controller: option3Controller,
          decoration: const InputDecoration(labelText: 'Option 3'),
          validator: (value) =>
              value!.isEmpty ? 'Enter option 3' : null,
        ),
        TextFormField(
          controller: option4Controller,
          decoration: const InputDecoration(labelText: 'Option 4'),
          validator: (value) =>
              value!.isEmpty ? 'Enter option 4' : null,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: correctAnswerIndex,
          decoration:
              const InputDecoration(labelText: 'Correct Option (0-3)'),
          items: List.generate(
            4,
            (index) => DropdownMenuItem(
              value: index,
              child: Text('Option ${index + 1}'),
            ),
          ),
          onChanged: (val) {
            correctAnswerIndex = val!;
          },
          validator: (value) =>
              value == null ? 'Select the correct option' : null,
        ),
      ],
    );
  }

  void dispose() {
    questionController.dispose();
    option1Controller.dispose();
    option2Controller.dispose();
    option3Controller.dispose();
    option4Controller.dispose();
  }
}
