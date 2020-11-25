import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../repository/repository_extensions.dart';
import 'bloc.dart';
import 'todo_state.dart';

class TodoBloc extends AutoLoadCubit<TodoState> {
  final TodoList todoList;
  final ITodoRepository iTodoRepository;

  TodoBloc({@required this.todoList, this.iTodoRepository});

  @override
  FutureOr<TodoState> loadInitialState() async {
    final List<Todo> todos = await iTodoRepository.getAllTodos(todoList);
    final List<double> previousPosition =
        todos.map((e) => 0.toDouble()).toList();
    return TodoState(todos: todos, previousPosition: previousPosition);
  }

  void toggleShowComplete() {
    emit(state.copyWith(showComplete: !state.showComplete));
  }

  Future<void> createTodo(String content) async {
    final uuid = Uuid();
    final createdOn = DateTime.now();
    final newTodo = Todo(id: uuid.v4(), content: content, createdOn: createdOn);

    await iTodoRepository.addTodo(todoList, newTodo);

    final todos = List<Todo>.from(state.todos);
    todos.add(newTodo);

    emit(state.copyWith(todos: todos));
  }

  Future<void> deleteTodo(Todo todo) async {
    await iTodoRepository.deleteTodo(todoList, todo);

    final todos = List<Todo>.from(state.completeTodos);
    todos.remove(todo);

    emit(state.copyWith(todos: todos));
  }

  Future<bool> completeTodo(Todo todo) async {
    final updatedTodo =
        await iTodoRepository.toggleTodoComplete(todoList, todo);

    final todos = List<Todo>.from(state.todos);
    todos.add(updatedTodo);
    todos.remove(todo);

    emit(state.copyWith(todos: todos));

    return updatedTodo.isComplete;
  }

  Future<void> update(Todo todo) async {
    final updatedTodo = await iTodoRepository.updateTodo(todoList, todo);

    final todos = List<Todo>.from(state.todos);

    for (int i = 0; i < todos.length; i++) {
      if (todos[i].id == updatedTodo.id) {
        todos[i] = updatedTodo;

        emit(state.copyWith(todos: todos));
      }
    }
  }
}
