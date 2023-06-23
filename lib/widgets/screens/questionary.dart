import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/widgets/questionary.dart';
import 'package:flutter/material.dart';

class QuestionaryScreen extends StatelessWidget {
  final List<Question> questions;
  final IProgressRepository repository;
  final String title;

  const QuestionaryScreen({
    super.key,
    required this.questions,
    required this.repository,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title 🇩🇪'),
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
