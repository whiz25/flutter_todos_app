import 'dart:async';

import 'package:flutter/material.dart';

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
    final List<Todo> incompleteTodos =
        await iTodoRepository.getAllIncompleteTodos(todoList);
    final List<Todo> completeTodos =
        await iTodoRepository.getAllCompleteTodos(todoList);
    return TodoState(
        incompleteTodos: incompleteTodos, completeTodos: completeTodos);
  }

  Future<void> createTodo(String content, TodoList todoList) async {
    final Todo newTodo = Todo(id: todoList.id, content: content);

    await iTodoRepository.addTodo(todoList, newTodo);

    final incompleteTodos = List<Todo>.from(state.incompleteTodos);
    incompleteTodos.add(newTodo);

    emit(state.copyWith(incompleteTodos: incompleteTodos));
  }

  Future<void> deleteTodo(Todo todo) async {
    await iTodoRepository.deleteTodo(todoList, todo);

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
    final todoStatus = await iTodoRepository.toggleTodoComplete(todoList, todo);

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

  Future<void> update(Todo todo) async {
    final updatedTodo = await iTodoRepository.updateTodo(todoList, todo);

    if (updatedTodo.isComplete) {
      final List<Todo> completeTodos = List.from(state.completeTodos);

      for (int i = 0; i < completeTodos.length; i++) {
        if (completeTodos[i].id == updatedTodo.id) {
          completeTodos[i] = updatedTodo;

          emit(state.copyWith(completeTodos: completeTodos));
        }
      }
    }

    final List<Todo> incompleteTodos = List.from(state.incompleteTodos);

    for (int i = 0; i < incompleteTodos.length; i++) {
      if (incompleteTodos[i].id == updatedTodo.id) {
        incompleteTodos[i] = updatedTodo;

        emit(state.copyWith(incompleteTodos: incompleteTodos));
      }
    }
  }
}
