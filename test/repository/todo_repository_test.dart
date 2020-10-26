import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todos_app/model/todo.dart';
import 'package:flutter_todos_app/model/todo_list.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';
import 'package:flutter_todos_app/repository/repository_extensions.dart';
import 'package:uuid/uuid.dart';

void main() {
  ITodoRepository todoRepository;
  TodoList todoList;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();    
    
    const MethodChannel channel =
        MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async => '.');
    
    await TodoRepository.initialize();
  });

  setUp(() async {    
    todoRepository = TodoRepository();
    todoList = await todoRepository.addTodoList(TodoList(
      id: Uuid().v4(),
      title: 'Test List'
      )
    );
  });

  tearDown(() async {
    final allLists = await todoRepository.getAllTodoLists();
    for (final todoList in allLists)
    {
      await todoRepository.deleteTodoList(todoList);
    }    
  });

  test('Test addNewTodo()', () async {    
    List<Todo> todos = await todoRepository.getAllTodos(todoList);

    expect(todos.length, 0);

    var newTodo = Todo(
      id: Uuid().v4(),
      content: 'Code in Flutter'
    );
    newTodo = await todoRepository.addTodo(todoList, newTodo);

    var anotherNewTodo = Todo(
      id: Uuid().v4(),
      content: 'Code in Dart'
    );
    anotherNewTodo = await todoRepository.addTodo(todoList, anotherNewTodo);

    todos = await todoRepository.getAllTodos(todoList);
    expect(todos.length, 2);    
  });

  test('Test deleteTodo()', () async {
    List<Todo> todos = await todoRepository.getAllTodos(todoList);
    expect(todos.length, 0);
    
    final Todo todoToDelete = 
      await todoRepository.addTodoFromContent(todoList, 'Test Content');

    todos = await todoRepository.getAllTodos(todoList);
    expect(todos.length, 1);

    await todoRepository.deleteTodo(todoList, todoToDelete);

    todos = await todoRepository.getAllTodos(todoList);
    expect(todos.length, 0);
  });

  test('Test updateTodo()', () async {
    final Todo existingTodo =
       await todoRepository.addTodoFromContent(todoList, 'Code in Dart');
    expect(existingTodo.content, 'Code in Dart');
    
    existingTodo.content = 'Code in Python';
    await todoRepository.updateTodo(todoList, existingTodo);

    final todos = await todoRepository.getAllTodos(todoList);    
    expect(todos.first.content, 'Code in Python');
  });

  test('Test completeTodo()', () async {
    final Todo existingTodo =
      await todoRepository.addTodoFromContent(todoList, 'test item');
    expect(existingTodo.isComplete, false);
    

    // Set Todo's complete status to true
    await todoRepository.toggleTodoComplete(todoList, existingTodo);
    var todos = await todoRepository.getAllTodos(todoList);    
    expect(todos.first.isComplete, true);

    // Set Todo's complete status to false
    await todoRepository.toggleTodoComplete(todoList, todos.first);
    todos = await todoRepository.getAllTodos(todoList);    
    expect(todos.first.isComplete, false);
  });
}
