import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoState {
  final List<Todo> todos;
  Iterable<Todo> get incompleteTodos => todos.where((todo) => !todo.isComplete);
  Iterable<Todo> get completeTodos => todos.where((todo) => todo.isComplete);

  TodoState({@required this.todos});

  TodoState copyWith({List<Todo> todos}) =>
      TodoState(todos: todos ?? this.todos);
}
