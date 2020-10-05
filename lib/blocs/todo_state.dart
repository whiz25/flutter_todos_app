import 'package:flutter/material.dart';

import '../model/todo.dart';

class TodoState {
  List<Todo> incompleteTodos;
  List<Todo> completeTodos;

  TodoState({@required this.incompleteTodos, @required this.completeTodos});

  TodoState copyWith({List<Todo> incompleteTodos, List<Todo> completeTodos}) =>
      TodoState(
          incompleteTodos: incompleteTodos ?? this.incompleteTodos,
          completeTodos: completeTodos ?? this.completeTodos);
}
