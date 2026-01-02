
import '../domain/question_model.dart';

class QuestionnaireRepository {
  // Mock data for now (will replace with Data Connect later)
  final List<Question> _questions = [
    Question(
      id: 'q1',
      text: 'Do you believe honesty is always the best policy, even if it hurts?',
      type: QuestionType.yesNo,
      domainMappings: {'ethics': 0.8},
    ),
    Question(
      id: 'q2',
      text: 'How important is financial independence to you?',
      type: QuestionType.scale,
      domainMappings: {'money': 0.9, 'autonomy': 0.6},
    ),
    Question(
      id: 'q3',
      text: 'Rank these in order of priority: Career, Family, Hobbies',
      type: QuestionType.ranked,
      domainMappings: {'ambition': 0.5, 'commitment': 0.7},
    ),
  ];

  Future<List<Question>> fetchQuestions() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _questions;
  }

  Future<void> submitAnswer(Answer answer) async {
    // Simulate submission
    await Future.delayed(const Duration(milliseconds: 500));
    print('Submitted answer for ${answer.questionId}: ${answer.value}');
  }
}

