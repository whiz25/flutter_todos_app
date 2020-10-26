import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/todo.dart';
import '../model/todo_list.dart';
import 'itodo_repository.dart';

class TodoRepository implements ITodoRepository {
  Box _todoListBox;
  TodoRepository();

  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(TodoListAdapter());
  }

  @override
  Future<Todo> addTodo(TodoList todoList, Todo todo) async {    
    final todoBox = await getBoxForList(todoList);
    await todoBox.add(todo);    
    return todo;
  }
    
      @override
      Future<void> deleteTodo(TodoList todoList, Todo todo) async {        
        final todoBox = await getBoxForList(todoList);
        await todoBox.delete(todo.key);
      }
    
      @override
      Future<void> deleteTodoList(TodoList todoList) async {        
        await checkIfTodoListsBoxIsCreatedAndOpen();
        await _todoListBox.delete(todoList.key);

        final todoBox = await getBoxForList(todoList);
        await todoBox.deleteFromDisk();        
      }
    
      @override
      Future<List<Todo>> getAllTodos(TodoList todoList) async {
        final todoBox = await getBoxForList(todoList);        
        return todoBox.values.cast<Todo>().toList();    
      }
    
      @override
      Future<Todo> updateTodo(TodoList todoList, Todo todo) async {
        final todoBox = await getBoxForList(todoList);            
        await todoBox.put(todo.key, todo);    
        return todo;
      }     
    
      @override
      Future<TodoList> addTodoList(TodoList todoList) async {
        await checkIfTodoListsBoxIsCreatedAndOpen();
    
        await _todoListBox.add(todoList);
    
        return todoList;
      }
    
      @override
      Future<List<TodoList>> getAllTodoLists() async {
        await checkIfTodoListsBoxIsCreatedAndOpen();
    
        final Iterable<TodoList> todoLists = 
          _todoListBox.values.cast<TodoList>();
        return todoLists.toList();
      }

      @override
      Future deleteAllTodos(TodoList todoList) async {
        final todoBox = await getBoxForList(todoList);
        await todoBox.clear();
      }
    
      Future<void> checkIfTodoListsBoxIsCreatedAndOpen() async {
        _todoListBox ??= await Hive.openBox<TodoList>('allTodoLists');
    
        if (!(_todoListBox?.isOpen ?? false)) {
          return;
        }
      }
            
      Future<Box> getBoxForList(TodoList todoList) =>
        Hive.openBox<Todo>(todoList.id);
      
}
