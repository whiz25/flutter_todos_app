import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/model/todo.dart';

import '../utils/mock_todo_repository.dart';

void main() {
  test('Test Todo content', () async {
    final mockTodoRepository = MockTodoRepository();

    final todo = await mockTodoRepository.addNewTodo('content');

    final Todo newTodo = Todo(content: 'Some test content');

    expect(todo.content, newTodo.content);
  });

  test('Test Todo length', () async {
    final mockTodoRepository = MockTodoRepository();

    final List<Todo> todoList = [Todo(content: ''), Todo(content: '')];
    final todos = await mockTodoRepository.getAllTodos();

    expect(todoList.length, todos.length);
  });
}
