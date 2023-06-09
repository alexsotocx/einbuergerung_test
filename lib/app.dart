import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/app.dart';

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
      dependencies['question_answered_repo'] = null;
    } else {
      dependencies['question_answered_repo'] =
          MemoryProgressRepoistory.withEmpty(questions.length);
    }

    final repo = _getDependency<IProgressRepository>('question_answered_repo');

    return MyApp(
      questions: questions,
      repository: repo,
    );
  }

  T _getDependency<T>(String key) {
    return dependencies[key] as T;
  }
}
