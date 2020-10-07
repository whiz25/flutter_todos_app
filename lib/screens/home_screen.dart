import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/todo_list_bloc.dart';
import '../blocs/todo_list_state.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';
import '../widgets/progress_loader.dart';
import 'todo_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TodoListBloc todoListBloc;
  TextEditingController todoListInputController;

  @override
  void initState() {
    super.initState();

    todoListBloc = TodoListBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    todoListInputController = TextEditingController();
  }

  @override
  void dispose() {
    todoListBloc.close();

    super.dispose();
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
                child: _todoLists(state)),
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

  Widget _todoLists(TodoListState state) => ListView.separated(
      separatorBuilder: (context, index) => const Divider(
            thickness: 1,
          ),
      itemCount: state.todoList.length,
      itemBuilder: (context, index) {
        final TodoList todoList = state.todoList[index];
        return Card(
          child: ListTile(
              leading: Icon(
                Icons.list,
                size: 35,
                color: AppColorPalette().primaryColor,
              ),
              title: Text(todoList.title),
              onTap: () {
                Navigator.of(context).push<Widget>(
                    MaterialPageRoute<Widget>(
                      builder: (context) => 
                      TodoListScreen(todoList: todoList,)));
              }),
        );
      });

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
                onPressed: () {
                  if (todoListInputController.text.isNotEmpty) {
                    todoListBloc.createTodoList(
                      todoListInputController.text,
                    );
                    todoListInputController.clear();

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          ));
}
