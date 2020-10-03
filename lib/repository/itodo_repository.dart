import '../model/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo> addTodo(Todo todo);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Future<bool> completeTodo(Todo todo);
}
