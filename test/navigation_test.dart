import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jade/main.dart';

void main() {
  testWidgets('startup', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JadeApp());

    expect(find.widgetWithText(Text, 'Logins'), findsOneWidget);
  });
}
