import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:graphic_calculator/main.dart';

void main() {
  testWidgets('Calculator displays initial value', (WidgetTester tester) async {
    await tester.pumpWidget(const GraphicCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.text('0'), findsAtLeastNWidgets(1));
  });

  testWidgets('Calculator has keyboard buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const GraphicCalculatorApp());
    await tester.pumpAndSettle();

    expect(find.byType(GridView), findsOneWidget);
    expect(find.byType(Material), findsWidgets);
  });
}
