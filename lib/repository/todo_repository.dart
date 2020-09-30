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
  Future<void> deleteTodoByIndex(int index) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.deleteAt(index);
  }

  @override
  Future<Iterable<Todo>> getAllTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    final Iterable<Todo> todos = _todoBox.values as Iterable<Todo>;
    return todos;
  }

  @override
  Future<void> updateTodoByIndex(int index, String content) async {
    await checkIfBoxIsCreatedAndOpen();

    final updatedTodo = Todo()..content = content;

    await _todoBox.putAt(index, updatedTodo);
  }

  Future<void> checkIfBoxIsCreatedAndOpen() async {
    _todoBox ??= await Hive.openBox<Todo>('todos');

    if (!(_todoBox?.isOpen ?? false)) {
      return;
    }
  }

  Future<void> resetTodoBox() async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.clear();
  }
}
