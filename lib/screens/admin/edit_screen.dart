import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionForm extends StatefulWidget {
  final String? quizId; // Null for new quiz, non-null for editing
  final Map<String, dynamic>? initialData;

  const QuestionForm({this.quizId, this.initialData, super.key});

  @override
  State<QuestionForm> createState() => _QuestionFormState();
}

class _QuestionFormState extends State<QuestionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    final data = widget.initialData ?? {};
    _titleController = TextEditingController(text: data['title'] ?? '');
    _descriptionController = TextEditingController(text: data['description'] ?? '');
    _questions = List<Map<String, dynamic>>.from(data['questions'] ?? []);
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'options': ['', '', '', ''],
        'correctAnswerIndex': 0,
      });
    });
  }

  void _saveQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    final quizData = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'questions': _questions,
    };

    final quizzesRef = FirebaseFirestore.instance.collection('quizzes');

    if (widget.quizId == null) {
      await quizzesRef.add(quizData);
    } else {
      await quizzesRef.doc(widget.quizId).update(quizData);
    }

    if (context.mounted) Navigator.pop(context);
  }

  Widget _buildQuestionCard(int index) {
    final q = _questions[index];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextFormField(
              initialValue: q['question'],
              onChanged: (value) => q['question'] = value,
              decoration: const InputDecoration(labelText: 'Question'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Question cannot be empty' : null,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (_, optIndex) {
                return TextFormField(
                  initialValue: q['options'][optIndex],
                  onChanged: (val) => q['options'][optIndex] = val,
                  decoration: InputDecoration(labelText: 'Option ${optIndex + 1}'),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Option required' : null,
                );
              },
            ),
            DropdownButtonFormField<int>(
              value: q['correctAnswerIndex'],
              items: List.generate(4, (i) => DropdownMenuItem(value: i, child: Text('Correct Option ${i + 1}'))),
              onChanged: (val) => setState(() => q['correctAnswerIndex'] = val ?? 0),
              decoration: const InputDecoration(labelText: 'Correct Answer'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _questions.removeAt(index)),
                child: const Text('Remove'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.quizId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Quiz' : 'New Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) => val == null || val.isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 20),
              Text('Questions', style: Theme.of(context).textTheme.titleLarge),
              ..._questions.asMap().entries.map((entry) => _buildQuestionCard(entry.key)).toList(),
              TextButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuiz,
                child: Text(isEditing ? 'Update Quiz' : 'Save Quiz'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
