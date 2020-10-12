import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../blocs/todo_list_bloc.dart';
import '../blocs/todo_list_state.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';
import '../utils/localization.dart';
import '../widgets/progress_loader.dart';
import 'todo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoListBloc todoListBloc;
  TextEditingController todoListInputController;

  final GlobalKey<AnimatedListState> _todoListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    todoListBloc = TodoListBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    todoListInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    todoListBloc.close();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TodoListBloc, TodoListState>(
        cubit: todoListBloc,
        builder: (context, state) {
          if (state == null) {
            return const ProgressLoader();
          }
          return Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColorPalette().primaryColor,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        'All TodoLists',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                    Expanded(child: _todoLists(state)),
                  ],
                )),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _createTodoForm(context, todoListBloc),
              child: Icon(
                Icons.add,
                color: AppColorPalette().primaryColor,
              ),
            ),
          );
        },
      );

  Widget _todoLists(TodoListState state) => AnimatedList(
      key: _todoListKey,
      initialItemCount: state.todoList.length,
      itemBuilder: (context, index, animation) => SizeTransition(
          sizeFactor: animation, child: _todoList(state, index)));

  Future<Widget> _createTodoForm(
          BuildContext context, TodoListBloc todoListBloc) =>
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
                        const InputDecoration(labelText: 'Title here *'),
                    controller: todoListInputController,
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  todoListInputController.clear();

                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (todoListInputController.text.isNotEmpty) {
                    await todoListBloc.createTodoList(
                      todoListInputController.text,
                    );
                    todoListInputController.clear();

                    _todoListKey.currentState.insertItem(0);

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          ));

  Widget _todoList(TodoListState state, int index) {
    final TodoList todoList = state.todoList[index];
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push<Widget>(MaterialPageRoute<Widget>(
              builder: (context) => TodoListScreen(
                    todoList: todoList,
                  )));
        },
        leading: Icon(
          Icons.list,
          size: 35,
          color: AppColorPalette().primaryColor,
        ),
        title: Text(
          todoList.title ?? '',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Future<bool> _confirmTodoListDelete(BuildContext context, int index,
      TodoListState state, TodoList todoList) async {
    await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('delete_todoList_start')} ${state.todoList[index].title} ${FlutterTodosAppLocalizations.of(context).translate('delete_todoList_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      todoListBloc.deleteTodoList(todoList);

                      _todoListKey.currentState.removeItem(
                          index,
                          (context, animation) => const SizedBox(
                                width: 0,
                                height: 0,
                              ));

                      Navigator.pop(context, true);
                    },
                    child: Text(
                        "${FlutterTodosAppLocalizations.of(context).translate('confirm')}",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Theme.of(context).accentColor))),
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
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
