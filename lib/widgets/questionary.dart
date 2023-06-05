import 'package:einbuergerung_test/models/answered_question.dart';
import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/widgets/nagivation.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';

class QuestionaryWidget extends StatefulWidget {
  final List<Question> questions;
  final IProgressRepository repository;

  const QuestionaryWidget({
    super.key,
    required this.questions,
    required this.repository,
  });

  @override
  State<QuestionaryWidget> createState() => _QuestionaryWidgetState();
}

class _QuestionaryWidgetState extends State<QuestionaryWidget> {
  List<String?>? _userAnswers;
  List<bool?>? _answerCorrect;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();

    _userAnswers = List.filled(widget.questions.length, null);
    _answerCorrect = List.filled(widget.questions.length, null);
  }

  Question _currentQuestion() {
    return widget.questions[_currentQuestionIndex];
  }

  Future<void> updateQuestion(bool correct) async {
    final currentQ = _currentQuestion();
    final currentAnswer = await widget.repository
        .getAllAnswered()
        .then((value) => value[currentQ.number]);
    if (currentAnswer == null) {
      await widget.repository.setAnsweredQuestion(AnsweredQuestion(
          questionId: currentQ.number,
          lastTimeCorrect: correct,
          timesCorrect: correct ? 1 : 0,
          timesIncorrect: correct ? 0 : 1));
    } else {
      await widget.repository.setAnsweredQuestion(AnsweredQuestion(
          questionId: currentQ.number,
          lastTimeCorrect: correct,
          timesCorrect: correct
              ? currentAnswer.timesCorrect + 1
              : currentAnswer.timesCorrect,
          timesIncorrect: correct
              ? currentAnswer.timesIncorrect
              : currentAnswer.timesIncorrect + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      QuestionWidget(
        key: Key('question_${_currentQuestion().number}'),
        question: _currentQuestion(),
        initialAnswer: _userAnswers![_currentQuestionIndex],
        onSelectAnswer: (correct, answer) => setState(() {
          _userAnswers![_currentQuestionIndex] = answer;
          _answerCorrect![_currentQuestionIndex] = correct;
          updateQuestion(correct);
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
      ),
      QuestionaryNavigator(
          answerCorrect: _answerCorrect!,
          currentQuestionIndex: _currentQuestionIndex,
          onPress: (q) => setState(() {
                _currentQuestionIndex = q;
              }))
    ]);
  }
}
