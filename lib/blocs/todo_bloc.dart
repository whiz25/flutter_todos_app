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
    final List<Todo> todos = await iTodoRepository.getAllTodos();
    return TodoState(todos: todos);
  }

  Future<void> createTodoItem(String content) async {
    final newTodo = await iTodoRepository.addNewTodo(content);

    final newList = List<Todo>.from(state.todos);
    newList.add(newTodo);

    state.copyWith(todos: newList);
  }

  Future<void> updateTodoItem(int id, String content) async {
    await iTodoRepository.updateTodoById(id, content);
  }

  Future<void> deleteTodoItem(int id) async {
    await iTodoRepository.deleteTodoById(id);
  }
}
