
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget createTestWidget(List<Widget> widgets) {
  return MaterialApp(
    home: Scaffold(body: Column(children: widgets)),
  );
}

Finder findButtonByText(String text) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is ElevatedButton &&
        widget.child is Text &&
        (widget.child as Text).data == text,
  );
}