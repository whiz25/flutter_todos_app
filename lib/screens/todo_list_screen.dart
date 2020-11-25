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
import 'screens.dart';

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
  TextEditingController contentInputController;

  final GlobalKey<AnimatedListState> _todoListKey =
      GlobalKey<AnimatedListState>();

  List<Todo> selected = [];

  @override
  void initState() {
    super.initState();

    _todoBloc = TodoBloc(
        todoList: widget.todoList,
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    _todoListBloc = TodoListBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    contentInputController = TextEditingController();
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
              onTap: () => FocusScope.of(context).unfocus(),
              child: FooterLayout(
                footer: TodoKeyboardAttachable(
                    todoBloc: _todoBloc, todoListKey: _todoListKey),
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
                        Expanded(child: _todosList(state))
                      ],
                    )),
              ),
            ),
          );
        },
      );

  AnimatedList _todosList(TodoState state) {
    final incompleteLength = state.incompleteTodos.length;
    return AnimatedList(
        key: _todoListKey,
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 4, right: 4),
        initialItemCount: state.todos.length + 1,
        itemBuilder: (context, index, animation) {
          if (index == incompleteLength) {
            return state.completeTodos.isNotEmpty
                ? Row(
                    children: [
                      if (state.showComplete)
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleDown),
                          onPressed: _todoBloc.toggleShowComplete,
                          color: AppColorPalette().whiteColor,
                        ),
                      if (!state.showComplete)
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.angleRight),
                          onPressed: _todoBloc.toggleShowComplete,
                          color: AppColorPalette().whiteColor,
                        ),
                      Text(
                        state.showComplete
                            ? 'Completed ${state.completeTodos.length}'
                            : 'Completed ${state.completeTodos.length}',
                        style: TextStyle(color: AppColorPalette().whiteColor),
                      ),
                    ],
                  )
                : null;
          }

          final offset = index < incompleteLength ? index : index - 1;

          return SlideTransition(
            position: animation.drive(Tween<Offset>(
                begin: Offset(0, state.previousPosition[offset]),
                end: const Offset(0, 0))),
            child: Dismissible(
              confirmDismiss: (direction) =>
                  _confirmTodoDelete(context, state, index),
              key: ValueKey(state.todos[offset]),
              child: state.todos[offset].isComplete
                  ? _showOrHideCompletedTodos(state, offset)
                  : _showIncompleteTodos(state, offset),
            ),
          );
        });
  }

  Widget _showOrHideCompletedTodos(TodoState state, int index) => Visibility(
        visible: state.showComplete,
        child: Card(
          child: ListTile(
            leading: state.todos[index].isComplete
                ? IconButton(
                    icon: Icon(
                      FontAwesomeIcons.solidCheckCircle,
                      size: 33,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      _completeTodo(state.todos[index], index, state);
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.circle,
                      size: 33,
                    ),
                    onPressed: () {
                      _completeTodo(state.todos[index], index, state);
                    },
                  ),
            title: Text(
              state.todos[index].content,
              style: state.todos[index].isComplete
                  ? const TextStyle(
                      fontSize: 20, decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TodoDetailsScreen(
                            todo: state.todos[index],
                            listTitle: widget.todoList.title,
                            onUpdated: _todoBloc.update,
                            onDeleted: _todoBloc.deleteTodo,
                          )));
            },
            subtitle: _checkTodoDueDate(state.todos[index]),
          ),
        ),
      );

  Widget _showIncompleteTodos(TodoState state, int index) => Dismissible(
        confirmDismiss: (direction) =>
            _confirmTodoDelete(context, state, index),
        key: ValueKey(state.todos[index]),
        child: Card(
          child: ListTile(
            leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.circle,
                size: 33,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                _completeTodo(state.todos[index], index, state);
              },
            ),
            title: Text(
              state.todos[index].content,
              style: state.todos[index].isComplete
                  ? const TextStyle(
                      fontSize: 20, decoration: TextDecoration.lineThrough)
                  : const TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.push<Widget>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TodoDetailsScreen(
                            todo: state.todos[index],
                            listTitle: widget.todoList.title,
                            onUpdated: _todoBloc.update,
                            onDeleted: _todoBloc.deleteTodo,
                          )));
            },
            subtitle: _checkTodoDueDate(state.todos[index]),
          ),
        ),
      );

  void _completeTodo(Todo todo, int index, TodoState state) {
    _todoBloc.completeTodo(todo);

    final currentTodo = state.todos[index];

    final newTodoList =
        List<Todo>.from(state.todos.where((todo) => todo != currentTodo));

    final newSelectionList =
        List<Todo>.from(selected.where((todo) => todo != currentTodo));

    final isSelected = selected.contains(currentTodo);

    if (isSelected) {
      state.todos.insert(0, currentTodo);
      state.previousPosition[0] = (index + 1).toDouble();
    } else {
      newSelectionList.add(currentTodo);

      state.previousPosition[state.todos.length - 1] =
          -1.0 * (state.todos.length - index).toDouble();
    }

    state.copyWith(todos: newTodoList);
    selected = newSelectionList;

    _todoListKey.currentState.removeItem(
        index,
        (context, animation) => SizeTransition(
              sizeFactor: animation.drive(Tween<double>(begin: 0, end: 1)),
            ));
    _todoListKey.currentState.insertItem(
        todo.isComplete ? 0 : state.todos.length - 1,
        duration: const Duration(milliseconds: 500));
  }

  Future<bool> _confirmTodoDelete(
      BuildContext context, TodoState state, int index) async {
    await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  // ignore: lines_longer_than_80_chars
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todo_start')} ${state.todos[index].content} ${FlutterTodosAppLocalizations.of(context).translate('delete_todo_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      _todoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));

                      _todoBloc.deleteTodo(state.todos[index]);

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
              title: Text(
                  // ignore: lines_longer_than_80_chars
                  '${FlutterTodosAppLocalizations.of(context).translate("delete")}'),
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

  Widget _checkTodoDueDate(Todo todo) {
    if (todo.dueDate != null) {
      if (todo.isDueDateExpired) {
        return _dueDateExpired(todo);
      }
      if (!todo.isDueDateExpired) {
        return _dueDateNotExpired(todo);
      }
    }
    return null;
  }

  Widget _dueDateExpired(Todo todo) => DueDateRow(
        calendarIcon: Icons.calendar_today,
        dueDateText:
            // ignore: lines_longer_than_80_chars
            '${todo.dayOfWeek(todo.dueDate)} ${todo.dayOfMonth(todo.dueDate)} ${todo.monthOfYear(todo.dueDate)}',
        dueDateColor: AppColorPalette().expiredDueDateColor,
      );

  Widget _dueDateNotExpired(Todo todo) => DueDateRow(
        calendarIcon: Icons.calendar_today,
        dueDateText:
            // ignore: lines_longer_than_80_chars
            '${todo.dayOfWeek(todo.dueDate)} ${todo.dayOfMonth(todo.dueDate)} ${todo.monthOfYear(todo.dueDate)}',
        dueDateColor: Theme.of(context).primaryColor,
      );
}
