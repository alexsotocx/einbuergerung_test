class AnsweredQuestion {
  final int questionId;
  final bool lastTimeCorrect;
  final int timesCorrect;
  final int timesIncorrect;

  AnsweredQuestion({
    required this.questionId,
    required this.lastTimeCorrect,
    required this.timesCorrect,
    required this.timesIncorrect,
  });
}
