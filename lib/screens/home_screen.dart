import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../animations/main_animation.dart';
import '../blocs/todo_bloc.dart';
import '../blocs/todo_state.dart';
import '../model/todo.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';
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

    mainAnimation = MainAnimation(animationController);
    animationController.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    todoBloc.close();
    animationController.dispose();

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
            body: Container(
                color: AppColorPalette().primaryColor,
                child: Column(
                  children: [
                    Expanded(child: _incompleteTodoList(state, context)),
                    if (state.completeTodos.isNotEmpty)
                      Text(
                        'Completed  ${state.completeTodos.length}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
                onPressed: () {
                  if (contentInputController.text.isNotEmpty) {
                    todoBloc.createTodo(contentInputController.text);
                    contentInputController.clear();

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
      child: ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, int index) => const Divider(
                thickness: 1,
              ),
          itemCount: todos.length,
          itemBuilder: (context, index) =>
              _incompleteTodoDismissible(state, index)),
    );
  }

  Widget _completeTodoList(TodoState state, BuildContext context) {
    final List<Todo> completeTodos = state.completeTodos;
    return ListView.separated(
        separatorBuilder: (context, int index) => const Divider(
              thickness: 1,
            ),
        itemCount: completeTodos.length,
        itemBuilder: (context, index) =>
            _completeTodoDismissible(state, index));
  }

  Widget _incompleteTodoDismissible(TodoState state, int index) {
    final Todo incompleteTodo = state.incompleteTodos[index];
    return Dismissible(
        confirmDismiss: (direction) =>
            _confirmTodoDelete(context, state, index),
        key: ValueKey(incompleteTodo),
        child: Card(
          child: ListTile(
              leading: IconButton(
                onPressed: () {
                  todoBloc.completeTodo(incompleteTodo);
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
    final Todo todo = state.completeTodos[index];
    return Dismissible(
        confirmDismiss: (direction) =>
            _confirmTodoDelete(context, state, index),
        key: ValueKey(todo),
        child: Card(
          child: ListTile(
              leading: IconButton(
                  onPressed: () {
                    todoBloc.completeTodo(todo);
                  },
                  icon: Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    size: 35,
                    color: AppColorPalette().primaryColor,
                  )),
              title: Text(
                todo.content ?? '',
                style: const TextStyle(fontSize: 20, 
                decoration: TextDecoration.lineThrough),
              ),
              onTap: () {}),
        ));
  }

  Future<bool> _confirmTodoDelete(
      BuildContext context, TodoState state, int index) async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('confirm')}"),
              content: Text(
                  "${FlutterTodosAppLocalizations.of(context).translate('remove_user_start')} ${state.incompleteTodos[index].content} ${FlutterTodosAppLocalizations.of(context).translate('remove_user_end')}"),
              actions: [
                FlatButton(
                    onPressed: () {
                      todoBloc.deleteTodo(state.incompleteTodos[index]);

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
