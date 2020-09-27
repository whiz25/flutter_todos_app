import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';
import 'package:mockito/mockito.dart';

import '../utils/mock_todo_repository.dart';

void main() {
  test('Test TodoRepository', () async {
    // initialize database
    await TodoRepository.initialize();

    var mockTodoRepository = MockTodoRepository();

    when(mockTodoRepository.getTodoById(1))
        .thenAnswer((_) async => Todo(content: 'Test some content'));

    var todoRepository = TodoRepository(innerRepository: mockTodoRepository);

    var todo1 = await todoRepository.getTodoById(1);

    var todo2 = await todoRepository.getTodoById(1);

    expect(todo1.content, todo2.content);
  });
}
