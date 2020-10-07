import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/blocs/todo_bloc.dart';
import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

void main() {
  TodoBloc todoBloc;
  ITodoRepository iTodoRepository;
  setUp(() {
    todoBloc.loadInitialState();
  });

  test('Test createTodo()', () async {
    await TodoRepository.initialize();

    // await todoBloc.createTodo('Code in flutter');

    // final List<Todo> todos = await iTodoRepository.getAllCompleteTodos();
    // expect(todos.length, 0);
  });
}
