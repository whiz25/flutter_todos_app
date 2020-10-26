import 'dart:async';
import 'package:uuid/uuid.dart';

import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import 'bloc.dart';
import 'todo_list_state.dart';

class TodoListBloc extends AutoLoadCubit<TodoListState> {
  final ITodoRepository iTodoRepository;

  TodoListBloc({this.iTodoRepository});

  @override
  FutureOr<TodoListState> loadInitialState() async {
    final List<TodoList> todoList = await iTodoRepository.getAllTodoLists();
    return TodoListState(todoList: todoList);
  }

  Future<void> createTodoList(String todoListTitle) async {
    final uuid = Uuid();
    final TodoList newTodoList = TodoList(id: uuid.v4(), title: todoListTitle);

    await iTodoRepository.addTodoList(newTodoList);

    final List<TodoList> newList = List<TodoList>.from(state.todoList);
    newList.add(newTodoList);

    emit(state.copyWith(todoList: newList));
  }

  Future<void> deleteTodoList(TodoList todoList) async {
    await iTodoRepository.deleteTodoList(todoList);

    final List<TodoList> newTodoList = List<TodoList>.from(state.todoList);
    newTodoList.remove(todoList);

    emit(state.copyWith(todoList: newTodoList));
  }
}
