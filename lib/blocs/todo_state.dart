import '../model/todo.dart';

class TodoState {
  List<Todo> todos;

  TodoState({this.todos});

  TodoState copyWith({List<Todo> todos}) =>
   TodoState(todos: todos ?? this.todos);
}
