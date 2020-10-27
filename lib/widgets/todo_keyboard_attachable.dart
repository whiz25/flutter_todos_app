import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../blocs/todo_bloc.dart';
import '../model/todo_list.dart';
import '../utils/app_color_palette.dart';
import '../utils/localization.dart';

class TodoKeyboardAttachable extends StatefulWidget {
  final TodoBloc todoBloc;
  final TodoList todoList;
  final GlobalKey<AnimatedListState> incompleteTodoListKey;

  const TodoKeyboardAttachable(
      {Key key, this.todoBloc, this.todoList, this.incompleteTodoListKey})
      : super(key: key);

  @override
  _TodoKeyboardAttachableState createState() => _TodoKeyboardAttachableState();
}

class _TodoKeyboardAttachableState extends State<TodoKeyboardAttachable> {
  TextEditingController contentInputController;

  @override
  void initState() {
    super.initState();

    contentInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: contentInputController,
              style:
                  TextStyle(color: AppColorPalette().containerBackgroundColor),
              decoration: InputDecoration(
                  hintText:
                      '${FlutterTodosAppLocalizations.of(context).translate("add_item")}',
                  hintStyle: TextStyle(
                      color: AppColorPalette().containerBackgroundColor),
                  fillColor: AppColorPalette().textFieldBackground,
                  filled: true,
                  border: const OutlineInputBorder(),
                  prefixIcon: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 30,
                        color: AppColorPalette().containerBackgroundColor,
                      ),
                      onPressed: () async {
                        if (contentInputController.text.isNotEmpty) {
                          await widget.todoBloc.createTodo(
                              contentInputController.text, widget.todoList);

                          contentInputController.clear();

                          widget.incompleteTodoListKey.currentState
                              .insertItem(0);
                        }
                      })),
            ),
          ),
        ),
      );
}
