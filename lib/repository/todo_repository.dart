import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import 'itodo_repository.dart';

class TodoRepository implements ITodoRepository {
  Box _todoBox;

  final ITodoRepository innerRepository;

  TodoRepository({this.innerRepository});

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(TodoListAdapter());
  }

  @override
  Future<Todo> addTodo(Todo todo, TodoList todoList) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.add(todo);

    // Create a HiveList from the Todo Box
    final HiveList hiveList = HiveList<TodoList>(_todoBox);
    hiveList.add(todo);

    return todo;
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.delete(todo.key);
  }

  @override
  Future<void> deletTodoList(TodoList todoList) async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.delete(todoList.key);
  }

  @override
  Future<List<Todo>> getAllIncompleteTodos(TodoList todoList) async {
    await checkIfBoxIsCreatedAndOpen();

    // final TodoList existingTodoList = _todoBox.get(todoList.key) as TodoList;

    //   final List<Todo> copyTodos = List<Todo>.from(existingTodoList);
    //   final List<Todo> incompleteTodos =
    //       copyTodos.where((t) => t.isComplete == false).toList();

    //   return incompleteTodos;
  }

  @override
  Future<List<Todo>> getAllCompleteTodos(TodoList todoList) async {
    await checkIfBoxIsCreatedAndOpen();

    // final TodoList existingTodoList = _todoBox.get(todoList.key) as TodoList;

    // if (existingTodoList.todos.isNotEmpty) {
    //   final List<Todo> copyTodos = List<Todo>.from(existingTodoList.todos);
    //   final List<Todo> completeTodos =
    //       copyTodos.where((c) => c.isComplete == true).toList();

    //   return completeTodos;
    // }

    // return null;
  }

  @override
  Future<Todo> updateTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

    final Todo updatedTodo = Todo()..content = todo.content;
    await _todoBox.put(todo.key, updatedTodo);

    return updatedTodo;
  }

  @override
  Future<bool> completeTodo(Todo todo) async {
    await checkIfBoxIsCreatedAndOpen();

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
    await checkIfBoxIsCreatedAndOpen();

    final _todoListBox = await Hive.openBox<TodoList>(todoList.id);
    await _todoBox.add(_todoListBox);

    return todoList;
  }

  @override
  Future<List<TodoList>> getAllTodoLists() async {
    await checkIfBoxIsCreatedAndOpen();

    final Iterable<TodoList> todoLists = _todoBox.values.cast<TodoList>();
    return todoLists.toList();
  }

  Future<void> checkIfBoxIsCreatedAndOpen() async {
    _todoBox ??= await Hive.openBox<List<TodoList>>('todoLists');

    if (!(_todoBox?.isOpen ?? false)) {
      return;
    }
  }

  Future<void> clearTodoBox() async {
    await checkIfBoxIsCreatedAndOpen();

    await _todoBox.clear();
  }
}
