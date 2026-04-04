// Smoke test básico do app
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psychapp/app/app.dart';

void main() {
  testWidgets('App smoke test - inicia sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: PsychApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
