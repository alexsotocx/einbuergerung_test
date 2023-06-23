class AnsweredQuestionResult {
  final int questionId;
  final bool lastTimeCorrect;
  final int timesCorrect;
  final int timesIncorrect;

  AnsweredQuestionResult({
    required this.questionId,
    required this.lastTimeCorrect,
    required this.timesCorrect,
    required this.timesIncorrect,
  });
}
