import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import 'itodo_repository.dart';

extension RepositoryExtensions on ITodoRepository {
  Future<bool> toggleTodoComplete(TodoList todoList, Todo todo) async
  {
      todo.isComplete = !todo.isComplete;
      final updated = await updateTodo(todoList, todo);
      return updated.isComplete;
  }

  Future<List<Todo>> getAllIncompleteTodos(TodoList todoList) async {      
      final todos = await getAllTodos(todoList);
  
      return todos.where((t) => !(t.isComplete ?? false))
          .toList();      
  }

  Future<List<Todo>> getAllCompleteTodos(TodoList todoList) async {
      final todos = await getAllTodos(todoList);
  
      return todos.where((t) => t.isComplete ?? false)
          .toList();      
  }

  Future<Todo> addTodoFromContent(TodoList todoList, String content) {
    final todo = Todo(
        id: Uuid().v4(),
        content: content
      );
    return addTodo(todoList, todo);
  }
}