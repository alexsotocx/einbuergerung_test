import 'package:einbuergerung_test/models/answered_question.dart';

abstract class IProgressRepository {
  Future<List<AnsweredQuestion?>> getAllAnswered();
  Future<AnsweredQuestion> setAnsweredQuestion(AnsweredQuestion q);
}

class MemoryProgressRepoistory extends IProgressRepository {
  final List<AnsweredQuestion?> answers;

  MemoryProgressRepoistory({
    required this.answers,
  });

  static MemoryProgressRepoistory withEmpty(int questionCount) {
    return MemoryProgressRepoistory(answers: List.filled(questionCount, null));
  }

  @override
  Future<List<AnsweredQuestion?>> getAllAnswered() {
    return Future.value(answers);
  }

  @override
  Future<AnsweredQuestion> setAnsweredQuestion(AnsweredQuestion q) {
    answers[q.questionId] = q;
    return Future.value(q);
  }
}
