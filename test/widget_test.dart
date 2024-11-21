import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lume_dating_app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify basic app structure
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Login screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify login button exists
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
