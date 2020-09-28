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
  Future<Todo> addNewTodo(String content) async {
    await checkIfBoxIsCreatedAndOpen();

    final newTodo = Todo()..content = content;
    await _todoBox.add(newTodo);

    return newTodo;
  }

  @override
  Future<void> deleteTodo(int id) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.delete(id);
  }

  @override
  Future<List<Todo>> getAllTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    final List<Todo> todos = _todoBox.get('todos') as List<Todo>;
    return todos;
  }

  @override
  Future<Todo> updateTodoById(int id) async {
    throw UnimplementedError();
  }

  Future<void> clearCache() async {
    _todoBox ??= await Hive.openBox<Todo>('todos');

    await _todoBox.clear();
  }

  Future<void> checkIfBoxIsCreatedAndOpen() async {
    _todoBox ??= await Hive.openBox<Todo>('todos');

    if (!(_todoBox?.isOpen ?? false)) {
      return;
    }
  }
}
