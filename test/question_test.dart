import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

class _MockFunctions extends Mock {
  void onNext();
  void onSelectAnswer(bool correct);
  void onPrevious();
}

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

void main() {
  var question = Question(
      answer: 'a',
      number: 1,
      options: ['a', 'b', 'c', 'd'],
      text: 'First letter of the abcd');

  testWidgets('find all data required for the question',
      (WidgetTester tester) async {
    var mocksCallbacks = _MockFunctions();

    await tester.pumpWidget(createTestWidget([
      QuestionWidget(
        question: question,
        onNext: mocksCallbacks.onNext,
        onPrevious: mocksCallbacks.onPrevious,
        onSelectAnswer: mocksCallbacks.onSelectAnswer,
      ),
    ]));

    expect(find.byType(RadioListTile<String>), findsNWidgets(4));
    for (var e in question.options) {
      expect(find.text(e), findsOneWidget);
    }

    expect(find.text(question.text), findsOneWidget);
  });

  group('CheckAnswer', () {
    group('when answer is correct', () {
      testWidgets('marks the answer as correct', (tester) async {
        final mocksCallbacks = _MockFunctions();

        await tester.pumpWidget(createTestWidget([
          QuestionWidget(
            question: question,
            onNext: mocksCallbacks.onNext,
            onPrevious: mocksCallbacks.onPrevious,
            onSelectAnswer: mocksCallbacks.onSelectAnswer,
          ),
        ]));

        final correctAnsOption = find.byKey(Key(question.answer));
        await tester.tap(correctAnsOption);

        final buttonWidget = findButtonByText('Check');

        await tester.tap(buttonWidget);
        verify(mocksCallbacks.onSelectAnswer(true));

        await tester.pumpAndSettle();

        expect(tester.widget<ElevatedButton>(buttonWidget).onPressed, isNull);
        expect(tester.widget<RadioListTile<String>>(correctAnsOption).onChanged,
            isNull);
      });
    });

    group('when answer is false', () {
      testWidgets('marks the answer as not correct', (tester) async {
        final mocksCallbacks = _MockFunctions();

        await tester.pumpWidget(createTestWidget([
          QuestionWidget(
            question: question,
            onNext: mocksCallbacks.onNext,
            onPrevious: mocksCallbacks.onPrevious,
            onSelectAnswer: mocksCallbacks.onSelectAnswer,
          ),
        ]));

        final falseOption = find.byKey(Key(question.options
            .firstWhere((element) => question.answer != element)));
        await tester.tap(falseOption);

        final buttonWidget = findButtonByText('Check');

        await tester.tap(buttonWidget);
        verify(mocksCallbacks.onSelectAnswer(false));

        await tester.pumpAndSettle();

        expect(tester.widget<ElevatedButton>(buttonWidget).onPressed, isNull);
        expect(tester.widget<RadioListTile<String>>(falseOption).onChanged,
            isNull);
      });
    });
  });
}
