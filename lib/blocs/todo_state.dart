import '../model/todo.dart';

class TodoState {
  final List<Todo> todos;
  final List<double> previousPosition;

  final bool showComplete;

  Iterable<Todo> get incompleteTodos => todos.where((todo) => !todo.isComplete);
  Iterable<Todo> get completeTodos => todos.where((todo) => todo.isComplete);

  TodoState({this.todos, this.previousPosition, this.showComplete = true});

  TodoState copyWith(
      {List<Todo> todos, List<double> previousPosition, bool showComplete}) {
    if (todos != null) {
      todos.sort((t1, t2) =>
          t1.isComplete == t2.isComplete ? 0 : (t1.isComplete ? 1 : -1));
    }
    return TodoState(
        todos: todos ?? this.todos,
        showComplete: showComplete ?? this.showComplete,
        previousPosition: previousPosition ?? this.previousPosition);
  }
}
