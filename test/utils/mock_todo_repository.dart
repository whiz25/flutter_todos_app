import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';

class MockTodoRepository implements ITodoRepository {
  @override
  Future<Todo> addNewTodo(String content) async {
    final Todo newTodo = Todo(content: 'Some test content');
    return newTodo;
  }

  @override
  Future<List<Todo>> getAllTodos() async{
    final List<Todo> todos = [
      Todo(content: 'Another test content'),
      Todo(content: 'Code in Flutter')
    ];
    return todos;
  }

  @override
  Future<void> updateTodoById(int id, String content) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodoById(int id) {
    throw UnimplementedError();
  }
}
