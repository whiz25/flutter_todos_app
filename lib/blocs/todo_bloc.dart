import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final List<Todo> incompleteTodos =
        await iTodoRepository.getAllIncompleteTodos(todoList);
    final List<Todo> completeTodos =
        await iTodoRepository.getAllCompleteTodos(todoList);
    return TodoState(
        incompleteTodos: incompleteTodos, completeTodos: completeTodos);
  }

  Future<void> createTodo(String content, TodoList todoList) async {
    final Todo newTodo = Todo(id: todoList.id, content: content);

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

  Future<void> setTodoDueDate(DateTime dateTime, Todo todo) async {
    todo.dueDate = dateTime;
    final Todo updatedTodo = await iTodoRepository.updateTodo(todo);

    final List<Todo> incompleteTodos = List.from(state.incompleteTodos);
    incompleteTodos.where((t) => t.id == updatedTodo.id);

    emit(state.copyWith(incompleteTodos: incompleteTodos));
  }

  String dayOfWeek(Todo todo) {
    final int day = todo.dueDate.weekday;
    switch (day) {
      case 1:
        return 'Mon';
        break;
      case 2:
        return 'Tue';
        break;
      case 3:
        return 'Wed';
        break;
      case 4:
        return 'Thu';
        break;
      case 5:
        return 'Fri';
        break;
      case 6:
        return 'Sat';
        break;
      case 7:
        return 'Sun';
        break;
      default:
        return 'Mon';
        break;
    }
  }

  String monthOfYear(Todo todo) => DateFormat.MMM().format(todo.dueDate);
  String dayOfMonth(Todo todo) => DateFormat.d().format(todo.dueDate);
}
