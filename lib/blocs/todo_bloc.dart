import 'dart:async';

import 'package:uuid/uuid.dart';

import '../model/todo.dart';
import '../repository/itodo_repository.dart';
import 'bloc.dart';
import 'todo_state.dart';

class TodoBloc extends AutoLoadCubit<TodoState> {
  final ITodoRepository iTodoRepository;

  TodoBloc({this.iTodoRepository});

  @override
  FutureOr<TodoState> loadInitialState() async {
    final List<Todo> incompleteTodos =
        await iTodoRepository.getAllIncompleteTodos();
    final List<Todo> completeTodos =
        await iTodoRepository.getAllCompleteTodos();
    return TodoState(
        incompleteTodos: incompleteTodos, completeTodos: completeTodos);
  }

  Future<void> createTodo(String content) async {
    final uuid = Uuid();

    final Todo newTodo = Todo()
      ..id = uuid.v4()
      ..content = content;

    await iTodoRepository.addTodo(newTodo);

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
}
