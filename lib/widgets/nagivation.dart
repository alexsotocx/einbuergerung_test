import 'package:flutter/material.dart';

class QuestionaryNavigator extends StatelessWidget {
  List<bool?> answerCorrect;
  void Function(int q) onPress;
  int currentQuestionIndex;
  QuestionaryNavigator(
      {super.key,
      required this.answerCorrect,
      required this.onPress,
      required this.currentQuestionIndex});

  TextStyle? textButtonStyle(int index) {
    if (answerCorrect[index] == null) return null;
    if (answerCorrect[index]!) return const TextStyle(color: Colors.green);
    return const TextStyle(color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemBuilder: (context, i) => TextButton(
          key: Key("nav$i"),
          onPressed: i == currentQuestionIndex ? null : () => onPress(i),
          child: Text("${i + 1}", style: textButtonStyle(i)),
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
