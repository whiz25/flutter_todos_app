import '../model/todo.dart';
import '../model/todo_list.dart';

abstract class ITodoRepository {
  Future<Todo> addTodo(TodoList todoList, Todo todo);  
  Future<Todo> updateTodo(TodoList todoList, Todo todo);
  Future<void> deleteTodo(TodoList todoList, Todo todo);  
  Future<List<Todo>> getAllTodos(TodoList todoList);
  Future deleteAllTodos(TodoList todoList);
  
  Future<TodoList> addTodoList(TodoList todoList);
  Future<void> deleteTodoList(TodoList todoList);  
  Future<List<TodoList>> getAllTodoLists();
}
