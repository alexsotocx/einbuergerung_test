import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/utils/read_json.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Question>? _questions;
  int _currentQuestionIndex = 0;
  List<String?>? _answers;
  bool _answerCorrect = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    loadJson('assets/questions.json').then((value) {
      setState(() {
        _questions = List.castFrom<dynamic, dynamic>(value)
            .map((e) => Question.fromJson(e))
            .toList();
        _questions!.shuffle();
        _answers = List.filled(_questions!.length, null);
      });
    });
  }

  void answerQuestion() {
    if (_selectedAnswer == null) return;
    setState(() {
      _answerCorrect =
          _questions![_currentQuestionIndex].answer == _selectedAnswer;
      _answers![_currentQuestionIndex] = _selectedAnswer;
      SharedPreferences.getInstance().then((value) =>
          value.setBool('answered$_currentQuestionIndex', _answerCorrect));
    });
  }

  void setSelectedAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions!.length) {
      setState(() {
        _currentQuestionIndex += 1;
        _answerCorrect = false;
        _selectedAnswer = null;
      });
    }
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
                    if (_answers![_currentQuestionIndex] != null)
                      Text(
                        _answerCorrect ? 'Gut gemacht' : 'Falsch',
                      ),
                    QuestionWidget(
                        onChangeAnswer: setSelectedAnswer,
                        answer: _currentQuestion().answer,
                        number: _currentQuestion().number,
                        text: _currentQuestion().text,
                        options: _currentQuestion().options,
                        link: _currentQuestion().link,
                        showIncorrect:
                            _answers![_currentQuestionIndex] != null),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_currentQuestionIndex > 0)
                          ElevatedButton(
                              onPressed: answerQuestion,
                              child: const Text('Previous')),
                        ElevatedButton(
                            onPressed: answerQuestion,
                            child: const Text('Check')),
                        if (_answers![_currentQuestionIndex] != null &&
                            _currentQuestionIndex < _questions!.length)
                          ElevatedButton(
                              onPressed: nextQuestion,
                              child: const Text('Weiter'))
                      ],
                    )
                  ],
                )),
    );
  }
}
