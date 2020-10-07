import '../model/todo.dart';
import '../model/todo_list.dart';

abstract class ITodoRepository {
  Future<List<Todo>> getAllIncompleteTodos(TodoList todoList);
  Future<List<Todo>> getAllCompleteTodos(TodoList todoList);
  Future<Todo> addTodo(Todo todo, TodoList todoList);
  Future<TodoList> addTodoList(TodoList todoList);
  Future<Todo> updateTodo(Todo todo);
  Future<void> deleteTodo(Todo todo);
  Future<void> deletTodoList(TodoList todoList);
  Future<bool> completeTodo(Todo todo);
  Future<List<TodoList>> getAllTodoLists();
}
