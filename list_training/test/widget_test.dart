// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:list_training/src/view/components/bottom_navigation.dart';

void main() {
  testWidgets('BottomNavigationBar items test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: BottomNavigationBarExample(),
    ));

    // Encontra o BottomNavigationBar
    final bottomNavigationBarFinder = find.byType(BottomNavigationBar);

    // Verifica se o BottomNavigationBar existe
    expect(bottomNavigationBarFinder, findsOneWidget);

    // Verifica o ícone e o rótulo de cada item
    final paginaHome = find.byIcon(Icons.home);
    final labelHome = find.text('Home');
    expect(paginaHome, findsOneWidget);
    expect(labelHome, findsOneWidget);

    final paginaBusiness = find.byIcon(Icons.business);
    final labelBusiness = find.text('Business');
    expect(paginaBusiness, findsOneWidget);
    expect(labelBusiness, findsOneWidget);

    final paginaPessoa = find.byIcon(Icons.person);
    final labelPessoa = find.text('Profile');
    expect(paginaPessoa, findsOneWidget);
    expect(labelPessoa, findsOneWidget);
  });
}
