import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import 'itodo_repository.dart';

class TodoRepository implements ITodoRepository {
  Box _todoBox;
  Box _todoListBox;

  final ITodoRepository innerRepository;

  TodoRepository({this.innerRepository});

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(TodoListAdapter());
  }

  @override
  Future<Todo> addTodo(Todo todo, TodoList todoList) async {
    await checkIfTodosBoxIsCreatedAndOpen();

    await _todoBox.add(todo);

    return todo;
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await checkIfTodosBoxIsCreatedAndOpen();

    await _todoBox.delete(todo.key);
  }

  @override
  Future<void> deletTodoList(TodoList todoList) async {
    await checkIfTodosBoxIsCreatedAndOpen();
    await checkIfTodoListsBoxIsCreatedAndOpen();

    await _todoBox.delete(todoList.key);
    await _todoListBox.delete(todoList.key);
  }

  @override
  Future<List<Todo>> getAllIncompleteTodos(TodoList todoList) async {
    await checkIfTodosBoxIsCreatedAndOpen();

    final Iterable<Todo> allIncompleteTodos = _todoBox.values.cast<Todo>();

    final List<Todo> incompleteTodos = allIncompleteTodos
        .where((t) => t.isComplete == false && t.id == todoList.id)
        .toList();

    return incompleteTodos;
  }

  @override
  Future<List<Todo>> getAllCompleteTodos(TodoList todoList) async {
    await checkIfTodosBoxIsCreatedAndOpen();
    await checkIfTodoListsBoxIsCreatedAndOpen();

    final Iterable<Todo> allCompleteTodos = _todoBox.values.cast<Todo>();

    final List<Todo> completeTodos = allCompleteTodos
        .where((c) => c.isComplete == true && c.id == todoList.id)
        .toList();

    return completeTodos;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    await checkIfTodosBoxIsCreatedAndOpen();

    final Todo updatedTodo = Todo(id: todo.id, content: todo.content, 
    dueDate: todo.dueDate);
    await _todoBox.put(todo.id, updatedTodo);

    return updatedTodo;
  }

  @override
  Future<bool> completeTodo(
    Todo todo,
  ) async {
    await checkIfTodosBoxIsCreatedAndOpen();

    if (todo.isComplete) {
      todo.isComplete = false;
      await _todoBox.put(todo.key, todo);
      return todo.isComplete;
    }

    todo.isComplete = true;
    await _todoBox.put(todo.key, todo);
    return todo.isComplete;
  }

  @override
  Future<TodoList> addTodoList(TodoList todoList) async {
    await checkIfTodoListsBoxIsCreatedAndOpen();

    await _todoListBox.add(todoList);

    return todoList;
  }

  @override
  Future<List<TodoList>> getAllTodoLists() async {
    await checkIfTodoListsBoxIsCreatedAndOpen();

    final Iterable<TodoList> todoLists = _todoListBox.values.cast<TodoList>();
    return todoLists.toList();
  }

  Future<void> checkIfTodoListsBoxIsCreatedAndOpen() async {
    _todoListBox ??= await Hive.openBox<TodoList>('allTodoLists');

    if (!(_todoListBox?.isOpen ?? false)) {
      return;
    }
  }

  Future<void> checkIfTodosBoxIsCreatedAndOpen() async {
    _todoBox ??= await Hive.openBox<Todo>('allTodos');

    if (!(_todoBox?.isOpen ?? false)) {
      return;
    }
  }

  Future<void> clearTodoBox() async {
    await checkIfTodosBoxIsCreatedAndOpen();

    await _todoBox.clear();
  }
}
