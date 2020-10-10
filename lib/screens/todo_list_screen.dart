import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/todo_bloc.dart';
import '../blocs/todo_state.dart';
import '../model/todo.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';
import '../utils/localization.dart';
import '../widgets/progress_loader.dart';

class TodoListScreen extends StatefulWidget {
  final TodoList todoList;
  const TodoListScreen({@required this.todoList, Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TodoBloc todoBloc;
  TextEditingController contentInputController;

  final GlobalKey<AnimatedListState> _incompleteTodoListKey =
      GlobalKey<AnimatedListState>();

  final GlobalKey<AnimatedListState> _completeTodoListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    todoBloc = TodoBloc(
        todoList: widget.todoList,
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    contentInputController = TextEditingController();
  }

  @override
  void dispose() {
    todoBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<TodoBloc, TodoState>(
        cubit: todoBloc,
        builder: (context, state) {
          if (state == null) {
            return const ProgressLoader();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: Container(
                color: AppColorPalette().primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.todoList.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                    Expanded(
                      child: _incompleteTodoList(state, context),
                    ),
                    if (state.completeTodos.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Completed  ${state.completeTodos.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    Expanded(child: _completeTodoList(state, context))
                  ],
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _createTodoForm(context, todoBloc),
              child: Icon(
                Icons.add,
                color: AppColorPalette().primaryColor,
              ),
            ),
          );
        },
      );

  Future<Widget> _createTodoForm(BuildContext context, TodoBloc bloc) =>
      showDialog<Widget>(
          context: context,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            content: Column(
              children: [
                const Text('Please fill out this form'),
                Expanded(
                  child: TextField(
                    decoration:
                        const InputDecoration(labelText: 'Content here *'),
                    controller: contentInputController,
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  contentInputController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (contentInputController.text.isNotEmpty) {
                    await todoBloc.createTodo(
                        contentInputController.text, widget.todoList);

                    contentInputController.clear();

                    _incompleteTodoListKey.currentState.insertItem(0);

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          ));

  Widget _incompleteTodoList(TodoState state, BuildContext context) {
    final List<Todo> todos = state.incompleteTodos;
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: AnimatedList(
          key: _incompleteTodoListKey,
          padding: const EdgeInsets.all(8),
          initialItemCount: todos.length,
          itemBuilder: (context, index, animation) => SizeTransition(
              sizeFactor: animation,
              child: _incompleteTodoDismissible(state, index))),
    );
  }

  Widget _completeTodoList(TodoState state, BuildContext context) {
    final List<Todo> completeTodos = state.completeTodos;
    return AnimatedList(
        key: _completeTodoListKey,
        padding: const EdgeInsets.all(8),
        initialItemCount: completeTodos.length,
        itemBuilder: (context, index, animation) => SizeTransition(
            sizeFactor: animation,
            child: _completeTodoDismissible(state, index)));
  }

  Widget _incompleteTodoDismissible(TodoState state, int index) {
    final Todo incompleteTodo = state.incompleteTodos[index];
    return Dismissible(
        confirmDismiss: (direction) => _confirmTodoDeleteIncompleteTodo(
            context, state, index, incompleteTodo),
        key: ValueKey(incompleteTodo),
        child: Card(
          child: ListTile(
              leading: IconButton(
                onPressed: () async {
                  _incompleteTodoListKey.currentState.removeItem(
                      index,
                      (context, animation) => const SizedBox(
                            width: 0,
                            height: 0,
                          ));

                  await todoBloc.completeTodo(incompleteTodo);

                  _completeTodoListKey.currentState.insertItem(0);
                },
                icon: const Icon(
                  FontAwesomeIcons.circle,
                  size: 35,
                ),
              ),
              title: Text(
                incompleteTodo.content ?? '',
                style: const TextStyle(fontSize: 20),
              ),
              onTap: () {}),
        ));
  }

  Widget _completeTodoDismissible(TodoState state, int index) {
    final Todo completeTodo = state.completeTodos[index];
    return Dismissible(
        confirmDismiss: (direction) =>
            _confirmTodoDeleteCompleteTodo(context, state, index, completeTodo),
        key: ValueKey(completeTodo),
        child: Card(
          child: ListTile(
              leading: IconButton(
                  onPressed: () async {
                    _completeTodoListKey.currentState.removeItem(
                        index,
                        (context, animation) => const SizedBox(
                              width: 0,
                              height: 0,
                            ));

                    await todoBloc.completeTodo(completeTodo);

                    _incompleteTodoListKey.currentState.insertItem(0);
                  },
                  icon: Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    size: 35,
                    color: AppColorPalette().primaryColor,
                  )),
              title: Text(
                completeTodo.content ?? '',
                style: const TextStyle(
                    fontSize: 20, decoration: TextDecoration.lineThrough),
              ),
              onTap: () {}),
        ));
  }

  Future<bool> _confirmTodoDeleteIncompleteTodo(
      BuildContext context, TodoState state, int index, Todo todo) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todo_start')} ${todo.content} ${FlutterTodosAppLocalizations.of(context).translate('delete_todo_end')}"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      _incompleteTodoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));

                      await todoBloc.deleteTodo(todo);

                      Navigator.pop(context, true);
                    },
                    child: Text(
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                        "${FlutterTodosAppLocalizations.of(context).translate('cancel')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor)))
              ],
            ));
    return true;
  }

  Future<bool> _confirmTodoDeleteCompleteTodo(
      BuildContext context, TodoState state, int index, Todo todo) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todo_start')} ${todo.content} ${FlutterTodosAppLocalizations.of(context).translate('delete_todo_end')}"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      _completeTodoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));
                              
                      await todoBloc.deleteTodo(todo);

                      Navigator.pop(context, true);
                    },
                    child: Text(
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                        "${FlutterTodosAppLocalizations.of(context).translate('cancel')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor)))
              ],
            ));
    return true;
  }
}