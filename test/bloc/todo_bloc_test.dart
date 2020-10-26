import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

void main(){
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();    
    
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '.');
    
    await TodoRepository.initialize();
  });

  test('Test Bloc',(){
    expect(1,1);
  });
}