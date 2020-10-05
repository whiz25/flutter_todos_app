import 'package:flutter_todos_app/model/todo_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/todo.dart';
import 'itodo_repository.dart';

class TodoRepository implements ITodoRepository {
  Box _todoBox;

  final ITodoRepository innerRepository;

  TodoRepository({this.innerRepository});

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(TodoListAdapter());
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.add(todo);

    return todo;
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.delete(todo.key);
  }

  @override
  Future<List<Todo>> getAllIncompleteTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    final Iterable<Todo> todos = _todoBox.values.cast<Todo>();
    final List<Todo> copyTodos = List<Todo>.from(todos);
    final List<Todo> incompleteTodos =
        copyTodos.where((t) => t.isComplete == false).toList();

    return incompleteTodos;
  }

  @override
  Future<List<Todo>> getAllCompleteTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    final Iterable<Todo> todos = _todoBox.values.cast<Todo>();
    final List<Todo> copyTodos = List<Todo>.from(todos);
    final List<Todo> completeTodos =
        copyTodos.where((c) => c.isComplete == true).toList();

    return completeTodos;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    final Todo updatedTodo = Todo()..content = todo.content;
    await _todoBox.put(todo.key, updatedTodo);

    return updatedTodo;
  }

  @override
  Future<bool> completeTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    if (todo.isComplete) {
      todo.isComplete = false;
      await _todoBox.put(todo.key, todo);
      return todo.isComplete;
    }

    todo.isComplete = true;
    await _todoBox.put(todo.key, todo);
    return todo.isComplete;
  }

  Future<void> checkIfBoxIsCreatedAndOpen() async {
    _todoBox ??= await Hive.openBox<Todo>('all_todos');

    if (!(_todoBox?.isOpen ?? false)) {
      return;
    }
  }

  Future<void> clearTodoBox() async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.clear();
  }
}
