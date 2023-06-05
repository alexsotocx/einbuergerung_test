import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/repositories/progress_repository.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/nagivation.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:einbuergerung_test/widgets/questionary.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einbürgerungtest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Question>? _questions;

  @override
  void initState() {
    super.initState();
    loadJson('assets/questions.json').then((value) {
      setState(() {
        _questions = List.castFrom<dynamic, dynamic>(value)
            .map((e) => Question.fromJson(e))
            .toList();
        // _questions!.shuffle();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einbürgerungtest Deutschland 🇩🇪'),
      ),
      body: Center(
          child: _questions == null
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    QuestionaryWidget(
                      questions: _questions!,
                      repository: MemoryProgressRepoistory.withEmpty(
                          _questions!.length + 1),
                    ),
                  ],
                )),
    );
  }
}
