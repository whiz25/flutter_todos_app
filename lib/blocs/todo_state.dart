import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoState {
  Iterable<Todo> todos;

  TodoState({@required this.todos});

  TodoState copyWith({List<Todo> todos}) =>
      TodoState(todos: todos ?? this.todos);
}
