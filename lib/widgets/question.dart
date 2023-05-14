import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final String text;
  final String? link;
  final String answer;
  final int number;
  final bool showIncorrect;
  final void Function(String answer) onChangeAnswer;
  final List<String> options;

  const QuestionWidget({
    super.key,
    required this.text,
    this.link,
    required this.answer,
    required this.options,
    required this.number,
    required this.showIncorrect,
    required this.onChangeAnswer,
  });

  @override
  State<StatefulWidget> createState() {
    return _QuestionWidgetState();
  }
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedAnswer;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${widget.number}: ${widget.text}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.link != null)
            InkWell(
              child: Text(
                widget.link!,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                // Open link
              },
            ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.options.map((ans) {
                return RadioListTile(
                    title: Text(
                      ans,
                      style: TextStyle(
                          color: widget.showIncorrect && ans != widget.answer
                              ? Colors.red
                              : Colors.black),
                    ),
                    value: ans,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      widget.onChangeAnswer(value!);
                      setState(() {
                        _selectedAnswer = value;
                      });
                    });
              }),
            ],
          ),
        ],
      ),
    );
  }
}
