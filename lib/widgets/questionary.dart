import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';

import '../models/question.dart';

class QuestionaryWidget extends StatefulWidget {
  final List<Question> questions;

  const QuestionaryWidget({
    super.key,
    required this.questions,
  });

  @override
  State<QuestionaryWidget> createState() => _QuestionaryWidgetState();
}

class _QuestionaryWidgetState extends State<QuestionaryWidget> {
  List<String?>? _userAnswers;
  List<bool>? _answerCorrect;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();

    _userAnswers = List.filled(widget.questions.length, null);
    _answerCorrect = List.filled(widget.questions.length, false);
  }

  Question _currentQuestion() {
    return widget.questions[_currentQuestionIndex];
  }

  @override
  Widget build(BuildContext context) {
    return QuestionWidget(
      key: Key('question_${_currentQuestion().number}'),
      question: _currentQuestion(),
      initialAnswer: _userAnswers![_currentQuestionIndex],
      onSelectAnswer: (correct, answer) => setState(() {
        _userAnswers![_currentQuestionIndex] = answer;
        _answerCorrect![_currentQuestionIndex] = correct;
      }),
      onNext: _currentQuestionIndex < widget.questions.length
          ? () => setState(() {
                _currentQuestionIndex = _currentQuestionIndex + 1;
              })
          : null,
      onPrevious: _currentQuestionIndex > 0
          ? () => setState(() {
                _currentQuestionIndex = _currentQuestionIndex - 1;
              })
          : null,
    );
  }
}
