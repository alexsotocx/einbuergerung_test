import 'package:einbuergerung_test/models/answered_question.dart';
import 'package:sqflite/sqlite_api.dart';

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

class SqlProgressRepository extends IProgressRepository {
  final Database dbClient;

  SqlProgressRepository({required this.dbClient});

  @override
  Future<List<AnsweredQuestion?>> getAllAnswered() async {
    final List<Map<String, dynamic>> maps = await dbClient.query('answers');

    return List.generate(maps.length, (i) {
      return AnsweredQuestion(
        lastTimeCorrect: maps[i]['lastTimeCorrect'] == 1,
        questionId: maps[i]['questionId'],
        timesCorrect: maps[i]['timesCorrect'],
        timesIncorrect: maps[i]['timesIncorrect'],
      );
    });
  }

  @override
  Future<AnsweredQuestion> setAnsweredQuestion(AnsweredQuestion q) async {
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
