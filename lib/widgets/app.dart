import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/widgets/questionary.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final List<Question> questions;
  final IProgressRepository repository;

  const MyApp({
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
      home: MyHomePage(
        repository: repository,
        questions: questions,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Question> questions;
  final IProgressRepository repository;

  const MyHomePage({
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
          QuestionaryWidget(questions: questions, repository: repository),
        ],
      )),
    );
  }
}
