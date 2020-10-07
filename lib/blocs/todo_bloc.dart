import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import 'bloc.dart';
import 'todo_state.dart';

class TodoBloc extends AutoLoadCubit<TodoState> {
  final TodoList todoList;
  final ITodoRepository iTodoRepository;

  TodoBloc({@required this.todoList, this.iTodoRepository});

  @override
  FutureOr<TodoState> loadInitialState() async {
    final Todo incompleteTodo = Todo(content: 'flutter', id: '10');
    final List<Todo> incompleteTodos = [incompleteTodo];
    // await iTodoRepository.getAllIncompleteTodos(todoList);
    final Todo completeTodo = Todo(content: 'python', id: '11');
    final List<Todo> completeTodos = [completeTodo];
    // await iTodoRepository.getAllCompleteTodos(todoList);
    return TodoState(
        incompleteTodos: incompleteTodos, completeTodos: completeTodos);
  }

  Future<void> createTodo(String content, TodoList todoList) async {
    final uuid = Uuid();

    final Todo newTodo = Todo(id: uuid.v4(), content: content);

    await iTodoRepository.addTodo(newTodo, todoList);

    final incompleteTodos = List<Todo>.from(state.incompleteTodos);
    incompleteTodos.add(newTodo);

    emit(state.copyWith(incompleteTodos: incompleteTodos));
  }

  Future<void> deleteTodo(Todo todo) async {
    await iTodoRepository.deleteTodo(todo);

    if (todo.isComplete) {
      final List<Todo> completeTodos = List<Todo>.from(state.completeTodos);
      completeTodos.remove(todo);

      emit(state.copyWith(completeTodos: completeTodos));
    }

    final List<Todo> incompleteTodos = List<Todo>.from(state.incompleteTodos);
    incompleteTodos.remove(todo);

    emit(state.copyWith(incompleteTodos: incompleteTodos));
  }

  Future<bool> completeTodo(Todo todo) async {
    final todoStatus = await iTodoRepository.completeTodo(todo);

    if (todoStatus) {
      final incompleteTodos = List<Todo>.from(state.incompleteTodos);
      final completeTodos = List<Todo>.from(state.completeTodos);

      incompleteTodos.remove(todo);
      emit(state.copyWith(incompleteTodos: incompleteTodos));

      completeTodos.add(todo);
      emit(state.copyWith(completeTodos: completeTodos));

      return todoStatus;
    }

    final completeTodos = List<Todo>.from(state.completeTodos);
    final incompleteTodos = List<Todo>.from(state.incompleteTodos);

    completeTodos.remove(todo);
    emit(state.copyWith(completeTodos: completeTodos));

    incompleteTodos.add(todo);
    emit(state.copyWith(incompleteTodos: incompleteTodos));

    return todoStatus;
  }
}
