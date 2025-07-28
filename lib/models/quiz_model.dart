class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Map<String, dynamic>> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory Quiz.fromMap(String id, Map<String, dynamic> data) {
    return Quiz(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      questions: List<Map<String, dynamic>>.from(data['questions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'questions': questions,
      'createdAt': DateTime.now(),
    };
  }
}
