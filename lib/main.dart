import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
  int _currentQuestionIndex = 0;
  List<String?>? _userAnswers;
  List<bool>? _answerCorrect;

  @override
  void initState() {
    super.initState();
    loadJson('assets/questions.json').then((value) {
      setState(() {
        _questions = List.castFrom<dynamic, dynamic>(value)
            .map((e) => Question.fromJson(e))
            .toList();
        _questions!.shuffle();
        _userAnswers = List.filled(_questions!.length, null);
        _answerCorrect = List.filled(_questions!.length, false);
      });
    });
  }

  Question _currentQuestion() {
    return _questions![_currentQuestionIndex];
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
                    QuestionWidget(
                      key: Key('question_${_currentQuestion().number}'),
                      question: _currentQuestion(),
                      initialAnswer: _userAnswers![_currentQuestionIndex],
                      onSelectAnswer: (correct, answer) => setState(() {
                        _userAnswers![_currentQuestionIndex] = answer;
                        _answerCorrect![_currentQuestionIndex] = correct;
                      }),
                      onNext: _currentQuestionIndex < _questions!.length
                          ? () => setState(() {
                                _currentQuestionIndex =
                                    _currentQuestionIndex + 1;
                              })
                          : null,
                      onPrevious: _currentQuestionIndex > 0
                          ? () => setState(() {
                                _currentQuestionIndex =
                                    _currentQuestionIndex - 1;
                              })
                          : null,
                    )
                  ],
                )),
    );
  }
}
