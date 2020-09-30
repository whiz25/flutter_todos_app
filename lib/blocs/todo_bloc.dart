import 'dart:async';

import '../model/todo.dart';
import '../repository/itodo_repository.dart';
import 'bloc.dart';
import 'todo_state.dart';

class TodoBloc extends AutoLoadCubit<TodoState> {
  final ITodoRepository iTodoRepository;

  TodoBloc({this.iTodoRepository});

  @override
  FutureOr<TodoState> loadInitialState() async {
    final Iterable<Todo> todos = await iTodoRepository.getAllTodos();
    return TodoState(todos: todos.toList());
  }

  Future<void> createTodoItem(String content) async {
    final newTodo = await iTodoRepository.addNewTodo(content);

    final newList = List<Todo>.from(state.todos);
    newList.add(newTodo);

    state.copyWith(todos: newList);
  }

  Future<void> updateTodoItem(int index, String content) async {
    await iTodoRepository.updateTodoByIndex(index, content);
  }

  Future<void> deleteTodoItem(int index) async {
    await iTodoRepository.deleteTodoByIndex(index);

    final newList = List<Todo>.from(state.todos);
    newList.removeAt(index);

    state.copyWith(todos: newList);
  }
}
