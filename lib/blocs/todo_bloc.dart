import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_todos_app/blocs/bloc.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:flutter_todos_app/blocs/todo_state.dart';

class TodoBloc extends AutoLoadCubit<TodoState> {
  final ITodoRepository iTodoRepository;

  TodoBloc({@required this.iTodoRepository});

  @override
  FutureOr<TodoState> loadInitialState() async {
    var todos = await this.iTodoRepository.getAllTodos();
    return TodoState(todos: todos);
  }
}
