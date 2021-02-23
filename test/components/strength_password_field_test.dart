import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fygo_assessment/components/strength_password_field.dart';

const _kStrongLabel = 'Strong Password';
const _kMediumLabel = 'Medium Password';
const _kWeakLabel = 'Weak Password';

Widget testableWidget({required Widget child}) {
  return MaterialApp(
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('Test that labels match', (WidgetTester tester) async {
    final label = 'My Label';

    final widget = StrengthField(label: label, onChanged: (_) {});

    await tester.pumpWidget(testableWidget(child: widget));
    expect(
      find.widgetWithText(StrengthField, label),
      findsOneWidget,
    );
  });
  testWidgets('Test onChange gets triggered', (WidgetTester tester) async {
    String value = '';
    final label = 'My Label';
    final onChanged = (val) => value = val;

    final widget = StrengthField(label: label, onChanged: onChanged);
    await tester.pumpWidget(testableWidget(child: widget));

    final foundWidget = find.widgetWithText(StrengthField, label).first;

    final inputText = 'Test';
    await tester.enterText(foundWidget, inputText);

    await tester.pumpAndSettle();
    expect(inputText, value,
        reason:
            'The value entered as text \"$inputText\" does not match \"$value\" got from onChanged');
  });

  testWidgets('Test for empty password', (WidgetTester tester) async {
    String password = '';
    final label = 'My Label';

    final widget = StrengthField(label: label, onChanged: (_) {});
    await tester.pumpWidget(testableWidget(child: widget));

    final foundWidget = find.widgetWithText(StrengthField, label).first;

    expect(find.widgetWithText(StrengthField, label), findsOneWidget);

    final inputText = password;
    await tester.enterText(foundWidget, inputText);

    await tester.pumpAndSettle();

    expect(find.text(_kWeakLabel), findsNothing);
    expect(find.text(_kMediumLabel), findsNothing);
    expect(find.text(_kStrongLabel), findsNothing);
  });

  testWidgets('Test for weak password', (WidgetTester tester) async {
    String password = '123';
    final label = 'My Label';

    final widget = StrengthField(label: label, onChanged: (_) {});
    await tester.pumpWidget(testableWidget(child: widget));

    final foundWidget = find.widgetWithText(StrengthField, label).first;

    expect(find.widgetWithText(StrengthField, label), findsOneWidget);

    final inputText = password;
    await tester.enterText(foundWidget, inputText);

    await tester.pumpAndSettle();

    expect(find.text(_kWeakLabel), findsOneWidget);
    expect(find.text(_kMediumLabel), findsNothing);
    expect(find.text(_kStrongLabel), findsNothing);
  });
  testWidgets('Test for medium password', (WidgetTester tester) async {
    String password = '1234';
    final label = 'My Label';

    final widget = StrengthField(label: label, onChanged: (_) {});
    await tester.pumpWidget(testableWidget(child: widget));

    final foundWidget = find.widgetWithText(StrengthField, label).first;

    expect(find.widgetWithText(StrengthField, label), findsOneWidget);

    final inputText = password;
    await tester.enterText(foundWidget, inputText);

    await tester.pumpAndSettle();

    expect(find.text(_kWeakLabel), findsNothing);
    expect(find.text(_kMediumLabel), findsOneWidget);
    expect(find.text(_kStrongLabel), findsNothing);
  });
  testWidgets('Test for strong password', (WidgetTester tester) async {
    String password = '1234567';
    final label = 'My Label';

    final widget = StrengthField(label: label, onChanged: (_) {});
    await tester.pumpWidget(testableWidget(child: widget));

    final foundWidget = find.widgetWithText(StrengthField, label).first;

    expect(find.widgetWithText(StrengthField, label), findsOneWidget);

    final inputText = password;
    await tester.enterText(foundWidget, inputText);

    await tester.pumpAndSettle();

    expect(find.text(_kWeakLabel), findsNothing);
    expect(find.text(_kMediumLabel), findsNothing);
    expect(find.text(_kStrongLabel), findsOneWidget);
  });
}
