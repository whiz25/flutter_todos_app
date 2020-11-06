import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import 'itodo_repository.dart';

extension RepositoryExtensions on ITodoRepository {
  Future<Todo> toggleTodoComplete(TodoList todoList, Todo todo) async {
    final updatedTodo = todo.copyWith(isComplete: !todo.isComplete);

    await updateTodo(todoList, updatedTodo);
    return updatedTodo;
  }

  Future<List<Todo>> getAllIncompleteTodos(TodoList todoList) async {
    final todos = await getAllTodos(todoList);

    return todos.where((todo) => !(todo.isComplete ?? false)).toList();
  }

  Future<List<Todo>> getAllCompleteTodos(TodoList todoList) async {
    final todos = await getAllTodos(todoList);

    return todos.where((todo) => todo.isComplete ?? false).toList();
  }

  Future<Todo> addTodoFromContent(TodoList todoList, String content) {
    final todo = Todo(id: Uuid().v4(), content: content);
    return addTodo(todoList, todo);
  }
}
