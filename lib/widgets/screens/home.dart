import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/utils/question_operations.dart';
import 'package:einbuergerung_test/widgets/screens/questionary.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Question> questions;
  final IProgressRepository repository;

  const HomeScreen({
    super.key,
    required this.questions,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einbürgerungtest Deutschland 🇩🇪'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionaryScreen(
                        questions: questions,
                        repository: repository,
                        title: 'Alle Frage'),
                  ));
            },
            child: const Text('Alle Frage'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final q = findAllWrongOrNotAnswered(
                  await repository.getAllAnswered(), questions);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionaryScreen(
                      questions: q,
                      repository: repository,
                      title: 'Questionary',
                    ),
                  ));
            },
            child: Text('Falsch geanwortet / nicht geanwortet'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final q = List<Question>.from(questions);
              q.shuffle();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionaryScreen(
                        title: 'Test mode',
                        questions: q.getRange(0, 33).toList(),
                        repository: repository),
                  ));
            },
            child: Text('Test mode'),
          ),
        ],
      )),
    );
  }
}
