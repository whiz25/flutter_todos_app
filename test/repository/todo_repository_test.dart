import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

void main() {
  final todoRepository = TodoRepository();

  test('Test addNewTodo()', () async {
    await TodoRepository.initialize();

    await todoRepository.clearTodoBox();

    final Iterable<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 0);

    expect(todos.length, 2);
  });

  test('Test deleteTodoByIndex()', () async {
    final Iterable<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 2);

    // await todoRepository.deleteTodoByIndex(0);

    // expect(todos.length, 1);

    // await todoRepository.deleteTodoByIndex(0);

    expect(todos.length, 0);
  });

  test('Test updateTodoByIndex()', () async {
    final Iterable<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 0);

    final Todo updatedTodo = todos.toList()[0];

    expect(updatedTodo.content, 'Code in Flutter');
  });
}
