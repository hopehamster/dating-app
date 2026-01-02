
enum QuestionType { yesNo, scale, ranked }

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final Map<String, dynamic> domainMappings;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.domainMappings,
  });
}

class Answer {
  final String questionId;
  final dynamic value; // bool, int (1-10), or List<String>
  final DateTime answeredAt;

  Answer({
    required this.questionId,
    required this.value,
    required this.answeredAt,
  });
}

