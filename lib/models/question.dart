class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctAnswerIndex: map['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
