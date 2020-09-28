import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

void main() {
  test('Test TodoRepository', () async {
    // initialize database
    await TodoRepository.initialize();

    // var mockTodoRepository = MockTodoRepository();
  });
}
