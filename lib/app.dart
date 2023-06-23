import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/screens/home.dart';
import 'package:einbuergerung_test/widgets/screens/questionary.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/question.dart';

enum RepositoryType { sql, memory }

class App extends StatelessWidget {
  final List<Question> questions;
  final IProgressRepository repository;

  const App({
    super.key,
    required this.questions,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einbürgerungtest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(repository: repository, questions: questions),
    );
  }
}

class AppBuilder {
  final Map<String, dynamic> dependencies = {};

  Future<Widget> build(RepositoryType repositoryType) async {
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

    return App(
      questions: questions,
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
