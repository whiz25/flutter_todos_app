import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';
import 'package:flutter_todos_app/screens/screens.dart';
import 'build_test_main.dart';

void main() {

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();    
    
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '.');
    
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