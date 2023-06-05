import 'package:flutter/material.dart';

class QuestionaryNavigator extends StatelessWidget {
  List<bool?> answerCorrect;
  void Function(int q) onPress;
  QuestionaryNavigator(
      {super.key, required this.answerCorrect, required this.onPress});

  @override
  Widget build(BuildContext context) {
    print("Testttttt");
    print(answerCorrect);
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        for (var i = 0; i < answerCorrect.length; i++) const Placeholder()
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   key: Key("nav$i"),
        //   child: TextButton(
        //       child: Text("${i + 1}"), onPressed: () => onPress(i)),
        // )
      ],
    );
  }
}
