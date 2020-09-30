import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';

class MockTodoRepository implements ITodoRepository {
  final List<Todo> todos = [
    Todo(content: 'Another test content'),
    Todo(content: 'Code in Flutter')
  ];

  @override
  Future<Todo> addNewTodo(String content) async {
    final Todo newTodo = Todo(content: content);
    todos.add(newTodo);
    return newTodo;
  }

  @override
  Future<List<Todo>> getAllTodos() async => todos;

  @override
  Future<Todo> updateTodoByIndex(int index, String content) async {
    final Todo newTodo = Todo(content: content);
    todos.removeAt(index);
    todos.insert(index, newTodo);

    return newTodo;
  }

  @override
  Future<void> deleteTodoByIndex(int index) async {
    todos.removeAt(index);
  }
}
