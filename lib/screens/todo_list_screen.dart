import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../blocs/todo_bloc.dart';
import '../blocs/todo_list_bloc.dart';
import '../blocs/todo_state.dart';
import '../model/todo.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';
import '../utils/localization.dart';
import '../widgets/widgets.dart';
import 'home_screen.dart';
import 'todo_details_screen.dart';

class TodoListScreen extends StatefulWidget {
  final TodoList todoList;
  const TodoListScreen({@required this.todoList, Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TodoList>('todoList', todoList));    
  }
}

class _TodoListScreenState extends State<TodoListScreen> {
  TodoBloc _todoBloc;
  TodoListBloc _todoListBloc;
  TextEditingController _contentInputController;

  final GlobalKey<AnimatedListState> _incompleteTodoListKey =
      GlobalKey<AnimatedListState>();

  final GlobalKey<AnimatedListState> _completeTodoListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _todoBloc = TodoBloc(
        todoList: widget.todoList,
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    _todoListBloc = TodoListBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    _contentInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _todoBloc.close();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<TodoBloc, TodoState>(
        cubit: _todoBloc,
        builder: (context, state) {
          if (state == null) {
            return const ProgressLoader();
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      _showPopupMenu(context);
                    },
                    icon: const Icon(Icons.more_horiz))
              ],
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: FooterLayout(
                footer: TodoKeyboardAttachable(
                    todoBloc: todoBloc,
                    todoList: widget.todoList,
                    incompleteTodoListKey: _incompleteTodoListKey),
                child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            widget.todoList.title,
                            style: TextStyle(
                                color: AppColorPalette().secondaryColor,
                                fontSize: 30),
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
                              style: TextStyle(
                                color: AppColorPalette().secondaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        Expanded(child: _completeTodoList(state, context)),
                      ],
                    )),
              ),
            ),
          );
        },
      );
  Widget _incompleteTodoList(TodoState state, BuildContext context) {
    final List<Todo> todos = state.incompleteTodos;
    return AnimatedList(
        key: _incompleteTodoListKey,
        padding: const EdgeInsets.all(8),
        initialItemCount: todos.length,
        itemBuilder: (context, index, animation) => SizeTransition(
            sizeFactor: animation,
            child: _incompleteTodoDismissible(state, index)));
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

                  await _todoBloc.completeTodo(incompleteTodo);

                  _completeTodoListKey.currentState.insertItem(0);
                },
                icon: const Icon(
                  FontAwesomeIcons.circle,
                  size: 35,
                ),
              ),
              title: Text(
                incompleteTodo.content ?? '',
                style: const TextStyle(fontSize: 22),
              ),
              subtitle: _checkTodoDueDate(incompleteTodo),
              onTap: () {
                Navigator.push<Widget>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TodoDetailsScreen(
                              todo: incompleteTodo,
                              listTitle: widget.todoList.title,
                              onUpdated: todoBloc.update,
                            )));
              }),
        ));
  }

  Widget _checkTodoDueDate(Todo todo) {
    if (todo.dueDate != null) {
      return Row(
        children: [
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
              // ignore: lines_longer_than_80_chars
              '${todo.dayOfWeek} ${todo.dueDate.day} ${todo.monthOfYear}'),
        ],
      );
    }
    return null;
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

                    await _todoBloc.completeTodo(completeTodo);

                    _incompleteTodoListKey.currentState.insertItem(0);
                  },
                  icon: Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  )),
              title: Text(
                completeTodo.content ?? '',
                style: const TextStyle(
                    fontSize: 22, decoration: TextDecoration.lineThrough),
              ),
              subtitle: _checkTodoDueDate(completeTodo),
              onTap: () {
                Navigator.of(context).push<Widget>(MaterialPageRoute(
                    builder: (context) => TodoDetailsScreen(
                          todo: completeTodo,
                          listTitle: widget.todoList.title,
                          onUpdated: todoBloc.update,
                        )));
              }),
        ));
  }

  Future<bool> _confirmTodoDeleteIncompleteTodo(
      BuildContext context, TodoState state, int index, Todo todo) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todo_start')} ${todo.content} ${FlutterTodosAppLocalizations.of(context).translate('delete_todo_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      _incompleteTodoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));

                      _todoBloc.deleteTodo(todo);

                      Navigator.pop(context, true);
                    },
                    child: Text(
                        // ignore: lines_longer_than_80_chars
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                        // ignore: lines_longer_than_80_chars
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
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todo_start')} ${todo.content} ${FlutterTodosAppLocalizations.of(context).translate('delete_todo_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      _completeTodoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));

                      _todoBloc.deleteTodo(todo);

                      Navigator.pop(context, true);
                    },
                    child: Text(
                        // ignore: lines_longer_than_80_chars
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                        // ignore: lines_longer_than_80_chars
                        "${FlutterTodosAppLocalizations.of(context).translate('cancel')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).primaryColor)))
              ],
            ));
    return true;
  }

  Future<void> _showPopupMenu(BuildContext context) => showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(25, 25, 0, 0),
          items: [
            PopupMenuItem(
                child: ListTile(
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.trashAlt),
                onPressed: () {
                  _confirmTodoListDelete(context, widget.todoList);
                },
              ),
              title: const Text('Delete'),
            ))
          ]);

  Future<bool> _confirmTodoListDelete(
      BuildContext context, TodoList todoList) async {
    await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todoList_start')} ${widget.todoList.title} ${FlutterTodosAppLocalizations.of(context).translate('delete_todoList_end')}"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      await _todoListBloc.deleteTodoList(todoList);

                      Navigator.pop(context, true);

                      await Navigator.push<Widget>(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    },
                    child: Text(
                        // ignore: lines_longer_than_80_chars
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).accentColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                        // ignore: lines_longer_than_80_chars
                        "${FlutterTodosAppLocalizations.of(context).translate('cancel')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).accentColor)))
              ],
            ));
    return true;
  }
}
