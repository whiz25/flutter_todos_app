import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:mockito/mockito.dart';

class MockTodoRepository extends Mock implements ITodoRepository {
  @override
  Future<Todo> addNewTodo(String content) {
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> getAllTodos() {
    throw UnimplementedError();
  }

  @override
  Future<void> updateTodoById(int id, String content) {
    throw UnimplementedError();
  }
}
