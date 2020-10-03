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
  Future<List<Todo>> getAllTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    final Iterable<Todo> todos = _todoBox.values.cast<Todo>();
    return todos.toList();
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    return todo;
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
