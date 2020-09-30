import '../model/todo.dart';

abstract class ITodoRepository {
  Future<Iterable<Todo>> getAllTodos();
  Future<Todo> addNewTodo(String content);
  Future<void> updateTodoByIndex(int index, String content);
  Future<void> deleteTodoByIndex(int index);
}
