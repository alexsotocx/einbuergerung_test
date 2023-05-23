import 'package:einbuergerung_test/models/question.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final void Function()? onNext;
  final void Function(bool correct, String selected) onSelectAnswer;
  final void Function()? onPrevious;
  final String? initialAnswer;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onSelectAnswer,
    this.onNext,
    this.onPrevious,
    this.initialAnswer,
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
  void initState() {
    super.initState();
    _selectedAnswer = widget.initialAnswer;
    _answered = widget.initialAnswer != null;
  }

  TextStyle? getTextStyle(bool correct) {
    if (!_answered) return null;
    return TextStyle(
      color: correct ? Colors.green : Colors.red,
    );
  }

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
                    style:
                        getTextStyle(questionOption == widget.question.answer),
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
                  if (_answered && widget.onPrevious != null)
                    ElevatedButton(
                        key: const Key('on_previous'),
                        onPressed: widget.onPrevious,
                        child: const Text('Previous')),
                  ElevatedButton(
                      key: const Key('on_check'),
                      onPressed: _answered
                          ? null
                          : () {
                              setState(() {
                                _answered = true;
                              });

                              widget.onSelectAnswer(
                                widget.question.answer == _selectedAnswer,
                                _selectedAnswer!,
                              );
                            },
                      child: const Text('Check')),
                  if (_answered && widget.onNext != null)
                    ElevatedButton(
                        key: const Key('on_next'),
                        onPressed: widget.onNext,
                        child: const Text('Next')),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
