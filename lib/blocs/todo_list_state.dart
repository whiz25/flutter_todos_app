import 'package:flutter/material.dart';

import '../model/todo_list.dart';

class TodoListState {
  List<TodoList> todoList;

  TodoListState({@required this.todoList});

  TodoListState copyWith({List<TodoList> todoList}) =>
      TodoListState(todoList: todoList ?? this.todoList);
}
