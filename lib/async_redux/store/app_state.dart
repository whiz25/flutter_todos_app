import 'package:flutter/material.dart';
import '../../model/todo.dart';

@immutable
class AppState {
  final DateTime dueDate;
  final Todo todo;

  const AppState({this.dueDate, this.todo});

  AppState copy({DateTime dueDate}) =>
      AppState(dueDate: dueDate ?? this.dueDate, todo: todo ?? todo);

  AppState initialState() => const AppState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState && dueDate == other.dueDate && todo == other.todo;

  @override
  int get hashCode => dueDate.hashCode;
}
