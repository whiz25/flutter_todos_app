import '../model/todo.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getAllTodos();
  Future<Todo> addNewTodo(String content);
  Future<void> updateTodoById(int id, String content);
  Future<void> deleteTodoById(int id);
}
