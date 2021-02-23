import 'package:flutter_test/flutter_test.dart';
import 'package:fygo_assessment/components/strength_password_field.dart';

import 'package:fygo_assessment/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Verify that a text field exists
    expect(find.widgetWithText(StrengthField, 'New Password'), findsOneWidget);
  });
}
