import 'package:einbuergerung_test/models/question.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final void Function() onNext;
  final void Function(bool correct) onSelectAnswer;
  final void Function() onPrevious;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onSelectAnswer,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedAnswer;
  bool _answered = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.question.text),
              const SizedBox(height: 16),
              ...widget.question.options.map((questionOption) {
                return RadioListTile<String>(
                  key: Key(questionOption),
                  title: Text(
                    questionOption,
                  ),
                  value: questionOption,
                  groupValue: _selectedAnswer,
                  onChanged: _answered
                      ? null
                      : (value) {
                          setState(() {
                            _selectedAnswer = value;
                          });
                        },
                );
              }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: _answered
                          ? null
                          : () {
                              setState(() {
                                _answered = true;
                              });
                              widget.onSelectAnswer(
                                  widget.question.answer == _selectedAnswer);
                            },
                      child: const Text('Check'))
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
