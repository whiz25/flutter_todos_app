import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../animations/main_animation.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_state.dart';
import '../model/todo.dart';
import '../repository/itodo_repository.dart';
import '../utils/localization.dart';
import '../widgets/progress_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TodoBloc todoBloc;
  TextEditingController contentInputController;
  AnimationController animationController;
  MainAnimation mainAnimation;

  @override
  void initState() {
    super.initState();

    todoBloc = TodoBloc(
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));

    contentInputController = TextEditingController();

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    animationController.forward();

    mainAnimation = MainAnimation(animationController);
    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();

    todoBloc.close();
    animationController.dispose();
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
              centerTitle: true,
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('appBarTitle')}"),
            ),
            body: _buildTodoList(state, context),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _createTodoForm(context, todoBloc),
              child: AnimatedIcon(
                  icon: AnimatedIcons.add_event,
                  progress: mainAnimation.animateFloatingActionButtonIcon),
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
                onPressed: () {
                  if (contentInputController.text.isNotEmpty) {
                    todoBloc.createTodoItem(contentInputController.text);
                    contentInputController.clear();

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              )
            ],
          ));

  Widget _buildTodoList(TodoState state, BuildContext context) {
    final Box<Todo> todosBox = Hive.box('todos');
    return ListView.separated(
        separatorBuilder: (context, int index) => const Divider(
              thickness: 1,
            ),
        itemCount: todosBox.length,
        itemBuilder: (context, index) =>
            _buildDismissible(state, index, todosBox));
  }

  Widget _buildDismissible(TodoState state, int index, Box<Todo> todosBox) {
    final todo = todosBox.getAt(index);
    return Dismissible(
        confirmDismiss: (direction) =>
            _confirmTodoDelete(context, state, index, todosBox),
        key: ValueKey(todosBox.getAt(index)),
        child: ListTile(
          title: Text(
            todo.content,
            style:
                TextStyle(fontSize: 40 * mainAnimation.listViewAnimation.value),
          ),
          onTap: () => _editTodoForm(context, index, todo),
        ));
  }

  Future<bool> _confirmTodoDelete(
      BuildContext context, TodoState state, int index, Box<Todo> box) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('remove_user_start')} ${box.getAt(index)} ${FlutterTodosAppLocalizations.of(context).translate('remove_user_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      todoBloc.deleteTodoItem(index);

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

  Future<Widget> _editTodoForm(BuildContext context, int index, Todo todo) =>
      showDialog<Widget>(
          context: context,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(10),
            content: Column(
              children: [
                const Text('Please update todo item'),
                Expanded(
                    child: TextField(
                  controller: contentInputController,
                  decoration: InputDecoration(labelText: todo.content),
                ))
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
              FlatButton(
                  onPressed: () {
                    todoBloc.updateTodoItem(index, contentInputController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'))
            ],
          ));
}
