import 'package:einbuergerung_test/models/answered_question.dart';
import 'package:einbuergerung_test/models/question.dart';

List<Question> findAllWrongOrNotAnswered(
  List<AnsweredQuestionResult> answeredQuestions,
  List<Question> questions,
) {
  return questions.where((q) {
    return !answeredQuestions.any(
      (qa) => qa.questionId == q.number && qa.lastTimeCorrect,
    );
  }).toList();
}
