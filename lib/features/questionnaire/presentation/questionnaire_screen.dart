
import 'package:flutter/material.dart';
import '../../matching/presentation/matches_screen.dart';
import '../domain/question_model.dart';
import '../repository/questionnaire_repository.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final QuestionnaireRepository _repository = QuestionnaireRepository();
  List<Question> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _repository.fetchQuestions();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _handleAnswer(dynamic value) {
    if (_currentIndex >= _questions.length) return;

    final currentQuestion = _questions[_currentIndex];
    final answer = Answer(
      questionId: currentQuestion.id,
      value: value,
      answeredAt: DateTime.now(),
    );

    _repository.submitAnswer(answer);

    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
      } else {
        // Finished - Show Matches
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MatchesScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions available.')),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Value Discovery'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  question.text,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 48),
            _buildInputForType(question),
          ],
        ),
      ),
    );
  }

  Widget _buildInputForType(Question question) {
    switch (question.type) {
      case QuestionType.yesNo:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _handleAnswer(false),
              icon: const Icon(Icons.close),
              label: const Text('No'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _handleAnswer(true),
              icon: const Icon(Icons.check),
              label: const Text('Yes'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        );
      case QuestionType.scale:
        return Slider(
          value: 5,
          min: 1,
          max: 10,
          divisions: 9,
          label: 'Importance',
          onChanged: (val) {
            // State needs to be managed for slider value specifically if dragged
          },
          onChangeEnd: (val) => _handleAnswer(val.round()),
        );
      case QuestionType.ranked:
        return ElevatedButton(
          onPressed: () => _handleAnswer(['Mock', 'Ranked', 'List']),
          child: const Text('Submit Ranking (Mock)'),
        );
    }
  }
}

