import '../model/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo> addNewTodo(String content);
  Future<Todo> updateTodoById(int id);
  Future<void> deleteTodo(int id);
}
