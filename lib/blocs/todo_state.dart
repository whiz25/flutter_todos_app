import 'package:flutter_todos_app/model/todo.dart';

class TodoState {
  Todo todos;

  TodoState({this.todos});

  TodoState copyWith({Todo todo}) {
    return TodoState(todos: todo ?? this.todos);
  }
}
