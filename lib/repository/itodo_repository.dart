import '../model/todo.dart';

abstract class ITodoRepository {
  Future<Todo> getAllTodos();
  Future<Todo> getTodoById(int id);
  Future<Todo> addNewTodo(Todo todo);
  Future<Todo> updateTodoById(int id);
  Future<void> deleteTodoById(int id);
}
