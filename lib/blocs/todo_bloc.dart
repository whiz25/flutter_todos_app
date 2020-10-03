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
    final List<Todo> todos = await iTodoRepository.getAllTodos();
    return TodoState(todos: todos);
  }

  Future<void> createTodo(String content) async {
    final uuid = Uuid();

    final Todo newTodo = Todo()
      ..id = uuid.v4()
      ..content = content;

    await iTodoRepository.addTodo(newTodo);

    final newList = List<Todo>.from(state.todos);
    newList.add(newTodo);

    final newState = state.copyWith(todos: newList);
    emit(newState);
  }

  Future<void> deleteTodo(Todo todo) async {
    await iTodoRepository.deleteTodo(todo);

    final newList = List<Todo>.from(state.todos);
    newList.remove(todo);

    final newState = state.copyWith(todos: newList);
    emit(newState);
  }

  Future<bool> completeTodo(Todo todo) async {
    final updatedTodo = await iTodoRepository.completeTodo(todo);
    todo.isComplete = updatedTodo;

    final newList = List<Todo>.from(state.todos);
    newList.where((t) => t.isComplete == todo.isComplete);

    final newState = state.copyWith(todos: newList);
    emit(newState);

    return updatedTodo;
  }
}
