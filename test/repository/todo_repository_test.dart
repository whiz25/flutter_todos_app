import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

void main() {
  final todoRepository = TodoRepository();

  test('Test addNewTodo()', () async {
    await TodoRepository.initialize();

    await todoRepository.clearTodoBox();

    List<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 0);

    final Todo newTodo = Todo(content: 'Code in Flutter');
    await todoRepository.addTodo(newTodo);

    final Todo anotherNewTodo = Todo(content: 'Code in Dart');
    await todoRepository.addTodo(anotherNewTodo);

    todos = await todoRepository.getAllTodos();

    expect(todos.length, 2);
  });

  test('Test deleteTodo()', () async {
    List<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 2);

    final Todo todoToDelete = todos[0];
    await todoRepository.deleteTodo(todoToDelete);

    todos = await todoRepository.getAllTodos();

    expect(todos.length, 1);
  });

  test('Test updateTodo()', () async {
    List<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 1);

    final Todo existingTodo = todos[0];
    expect(existingTodo.content, 'Code in Dart');

    final Todo todoToUpdate = todos[0];
    todoToUpdate.content = 'Code in Python';

    await todoRepository.updateTodo(todoToUpdate);

    todos = await todoRepository.getAllTodos();

    final Todo updatedTodo = todos[0];
    expect(updatedTodo.content, 'Code in Python');
  });

  test('Test completeTodo()', () async {
    List<Todo> todos = await todoRepository.getAllTodos();

    expect(todos.length, 1);

    final Todo existingTodo = todos[0];
    expect(existingTodo.isComplete, false);

    final Todo todoToComplete = todos[0];

    // Set Todo's complete status to true
    await todoRepository.completeTodo(todoToComplete);

    todos = await todoRepository.getAllTodos();

    final Todo completedTodoReturnsTrue = todos[0];
    expect(completedTodoReturnsTrue.isComplete, true);

    // Set Todo's complete status to false
    await todoRepository.completeTodo(todoToComplete);

    todos = await todoRepository.getAllTodos();

    final Todo completedTodoReturnsFalse = todos[0];
    expect(completedTodoReturnsFalse.isComplete, false);
  });
}
