import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:mockito/mockito.dart';

class MockTodoRepository extends Mock implements ITodoRepository {
  @override
  Future<Todo> addNewTodo(Todo todo) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTodoById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Todo> getAllTodos() {
    throw UnimplementedError();
  }

  @override
  Future<Todo> getTodoById(int id) async {
    // if (id == 1) {
    //   return Todo(id: 1, content: 'Test todo content', isComplete: false);
    // }
    throw UnimplementedError();
  }

  @override
  Future<Todo> updateTodoById(int id) {
    throw UnimplementedError();
  }
}
