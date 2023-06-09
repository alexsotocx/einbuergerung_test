import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/app.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/question.dart';

enum RepositoryType { sql, memory }

class AppBuilder {
  final Map<String, dynamic> dependencies = {};

  Future<MyApp> build(RepositoryType repositoryType) async {
    final questions = await loadJson('assets/questions.json').then((value) {
      return List.castFrom<dynamic, dynamic>(value)
          .map((e) => Question.fromJson(e))
          .toList();
    });

    if (repositoryType == RepositoryType.sql) {
      await _initializeSqlRepo();
    } else {
      dependencies['question_answered_repo'] =
          MemoryProgressRepoistory.withEmpty(questions.length);
    }

    final repo = _getDependency<IProgressRepository>('question_answered_repo');

    final answeredQuestions = await repo.getAllAnswered();
    final notAnsweredQuestions = questions.where((q) {
      return answeredQuestions.firstWhere(
            (qa) => qa!.questionId == q.number && qa.lastTimeCorrect,
            orElse: () => null,
          ) ==
          null;
    }).toList();

    return MyApp(
      questions: notAnsweredQuestions,
      repository: repo,
    );
  }

  Future<void> _initializeSqlRepo() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'answers.db'),
      onCreate: (db, version) {
        return db.execute('''
            CREATE TABLE answers(
              questionId INTEGER PRIMARY KEY,
              lastTimeCorrect INTEGER,
              timesCorrect INTEGER,
              timesIncorrect INTEGER
            )
          ''');
      },
      version: 1,
    );

    dependencies['question_answered_repo'] =
        SqlProgressRepository(dbClient: database);
  }

  T _getDependency<T>(String key) {
    return dependencies[key] as T;
  }
}
