import 'package:einbuergerung_test/models/question.dart';
import 'package:einbuergerung_test/widgets/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import '../utils.dart';

class _MockFunctions extends Mock {
  void onNext();
  void onSelectAnswer(bool correct, String answer);
  void onPrevious();
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

  group('action buttons', () {
    testWidgets('button is rendered', (tester) async {
      var mocksCallbacks = _MockFunctions();

      await tester.pumpWidget(createTestWidget([
        QuestionWidget(
          question: question,
          onNext: mocksCallbacks.onNext,
          onPrevious: mocksCallbacks.onPrevious,
          onSelectAnswer: mocksCallbacks.onSelectAnswer,
          initialAnswer: question.answer,
        ),
      ]));

      expect(find.byKey(const Key('on_next')), findsOneWidget);
      expect(find.byKey(const Key('on_previous')), findsOneWidget);
    });

    group('when on next/previous callback is not passed', () {
      testWidgets('button is not redered', (tester) async {
        var mocksCallbacks = _MockFunctions();

        await tester.pumpWidget(createTestWidget([
          QuestionWidget(
            question: question,
            onNext: null,
            onPrevious: null,
            onSelectAnswer: mocksCallbacks.onSelectAnswer,
          ),
        ]));

        expect(find.byKey(const Key('on_next')), findsNothing);
        expect(find.byKey(const Key('on_previous')), findsNothing);
      });
    });
  });

  group('CheckAnswer', () {
    testWidgets('show what are the wrong answers and correct one',
        (tester) async {
      final mocksCallbacks = _MockFunctions();

      await tester.pumpWidget(createTestWidget([
        QuestionWidget(
          question: question,
          onNext: mocksCallbacks.onNext,
          onPrevious: mocksCallbacks.onPrevious,
          onSelectAnswer: mocksCallbacks.onSelectAnswer,
        ),
      ]));

      var correctAnsOption = find.byKey(Key(question.answer));
      await tester.tap(correctAnsOption);

      final buttonWidget = findButtonByText('Check');

      await tester.tap(buttonWidget);

      await tester.pumpAndSettle();

      for (final q in question.options) {
        final optionWidget =
            tester.widget<RadioListTile>(find.byKey(Key(q))).title as Text;
        expect(optionWidget.style?.color,
            q == question.answer ? Colors.green : Colors.red);
      }
    });

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
        verify(mocksCallbacks.onSelectAnswer(true, question.answer));

        await tester.pumpAndSettle();

        expect(tester.widget<ElevatedButton>(buttonWidget).onPressed, isNull);
        expect(tester.widget<RadioListTile<String>>(correctAnsOption).onChanged,
            isNull);
      });
    });

    group('when answer is not correct', () {
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

        final wrongAnswerText = question.options
            .firstWhere((element) => question.answer != element);
        final falseOption = find.byKey(Key(wrongAnswerText));
        await tester.tap(falseOption);

        final buttonWidget = findButtonByText('Check');

        await tester.tap(buttonWidget);
        verify(mocksCallbacks.onSelectAnswer(false, wrongAnswerText));

        await tester.pumpAndSettle();

        expect(tester.widget<ElevatedButton>(buttonWidget).onPressed, isNull);
        expect(tester.widget<RadioListTile<String>>(falseOption).onChanged,
            isNull);
      });
    });
  });
}
