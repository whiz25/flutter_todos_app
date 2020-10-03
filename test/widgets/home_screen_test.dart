import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';
import 'package:flutter_todos_app/screens/screens.dart';

import 'build_test_main.dart';

void main() {
  setUp(() async {
    await TodoRepository.initialize();
  });

  testWidgets('Find the CircularProgressIndicator',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestMain(const HomeScreen()),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

  });
}
