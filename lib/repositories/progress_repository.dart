import 'package:einbuergerung_test/models/answered_question.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class IProgressRepository {
  Future<List<AnsweredQuestionResult>> getAllAnswered();
  Future<AnsweredQuestionResult> setAnsweredQuestion(AnsweredQuestionResult q);
}

class MemoryProgressRepoistory extends IProgressRepository {
  final List<AnsweredQuestionResult> answers;

  MemoryProgressRepoistory({
    required this.answers,
  });

  static MemoryProgressRepoistory withEmpty(int questionCount) {
    return MemoryProgressRepoistory(
        answers: List.generate(
      questionCount,
      (index) => AnsweredQuestionResult(
          questionId: index + 1,
          lastTimeCorrect: false,
          timesCorrect: 0,
          timesIncorrect: 0),
    ));
  }

  @override
  Future<List<AnsweredQuestionResult>> getAllAnswered() {
    return Future.value(answers);
  }

  @override
  Future<AnsweredQuestionResult> setAnsweredQuestion(AnsweredQuestionResult q) {
    answers[q.questionId] = q;
    return Future.value(q);
  }
}

class SqlProgressRepository extends IProgressRepository {
  final Database dbClient;

  SqlProgressRepository({required this.dbClient});

  @override
  Future<List<AnsweredQuestionResult>> getAllAnswered() async {
    final List<Map<String, dynamic>> maps = await dbClient.query('answers');

    return List.generate(maps.length, (i) {
      return AnsweredQuestionResult(
        lastTimeCorrect: maps[i]['lastTimeCorrect'] == 1,
        questionId: maps[i]['questionId'],
        timesCorrect: maps[i]['timesCorrect'],
        timesIncorrect: maps[i]['timesIncorrect'],
      );
    });
  }

  @override
  Future<AnsweredQuestionResult> setAnsweredQuestion(
      AnsweredQuestionResult q) async {
    await dbClient.insert(
        'answers',
        {
          'lastTimeCorrect': q.lastTimeCorrect ? 1 : 0,
          'questionId': q.questionId,
          'timesCorrect': q.timesCorrect,
          'timesIncorrect': q.timesIncorrect,
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    return q;
  }
}
