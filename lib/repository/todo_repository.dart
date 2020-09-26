import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoRepository implements ITodoRepository {
  Box _todoBox;

  final ITodoRepository innerRepository;

  TodoRepository({this.innerRepository});

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
  }

  @override
  Future<Todo> addNewTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    var newTodo = await innerRepository.addNewTodo(todo);
    this._todoBox.add(newTodo);

    return newTodo;
  }

  @override
  Future<void> deleteTodoById(int id) async {
    await checkIfBoxIsCreatedAndOpen();

    var todo = await innerRepository.getTodoById(id);
    this._todoBox.delete(todo);
  }

  @override
  Future<Todo> getAllTodos() async {
    await checkIfBoxIsCreatedAndOpen();

    var todos = this._todoBox.get('todos');
    return todos;
  }

  @override
  Future<Todo> getTodoById(int id) async {
    await checkIfBoxIsCreatedAndOpen();

    var todo = this._todoBox.get(id);

    return todo;
  }

  @override
  Future<Todo> updateTodoById(int id) async {
    throw UnimplementedError();
  }

  Future<void> clearCache() async {
    if (this._todoBox == null) {
      this._todoBox = await Hive.openBox<Todo>('todos');
    }

    await this._todoBox.clear();
  }

  Future<void> checkIfBoxIsCreatedAndOpen() async {
    if (this._todoBox == null) {
      this._todoBox = await Hive.openBox<Todo>('todos');
    }

    if (!(this._todoBox?.isOpen ?? false)) {
      return null;
    }
  }
}
