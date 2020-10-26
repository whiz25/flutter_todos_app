import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  TodoListBloc _todoListBloc;
  TextEditingController _todoListInputController;

  final GlobalKey<AnimatedListState> _todoListKey =
      GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    _todoListBloc = TodoListBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    _todoListInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _todoListBloc.close();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TodoListBloc, TodoListState>(
        cubit: _todoListBloc,
        builder: (context, state) {
          if (state == null) {
            return const ProgressLoader();
          }
          return Scaffold(
              body: Container(
                color: AppColorPalette().secondaryColor,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Divider(thickness: 1),
                    ),
                    Expanded(child: _todoLists(state)),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                color: AppColorPalette().secondaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () =>
                              _createTodoForm(context, _todoListBloc),
                          color: Theme.of(context).primaryColor,
                          iconSize: 30,
                        ),
                        Text(
                          'New List',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.group_add),
                      onPressed: () {},
                      color: Theme.of(context).primaryColor,
                      iconSize: 30,
                    )
                  ],
                ),
              ));
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
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  const Text('New list'),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter list title',
                      icon: Icon(Icons.list),
                    ),
                    controller: _todoListInputController,
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  _todoListInputController.clear();

                  Navigator.pop(context);
                },
                child: Text(
                    // ignore: lines_longer_than_80_chars
                    '${FlutterTodosAppLocalizations.of(context).translate("cancel")}',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              FlatButton(
                onPressed: () async {
                  if (_todoListInputController.text.isNotEmpty) {
                    await todoListBloc.createTodoList(
                      _todoListInputController.text,
                    );
                    _todoListInputController.clear();

                    _todoListKey.currentState.insertItem(0);

                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                    // ignore: lines_longer_than_80_chars
                    '${FlutterTodosAppLocalizations.of(context).translate("save")}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    )),
              )
            ],
          ));

  Widget _todoList(TodoListState state, int index) {
    final TodoList todoList = state.todoList[index];
    return ListTile(
      onTap: () {
        Navigator.of(context).push<Widget>(MaterialPageRoute<Widget>(
            builder: (context) => TodoListScreen(
                  todoList: todoList,
                )));
      },
      leading: Icon(
        Icons.list,
        size: 35,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        todoList.title ?? '',
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
