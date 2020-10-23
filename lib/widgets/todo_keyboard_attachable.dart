import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../blocs/todo_bloc.dart';
import '../model/todo_list.dart';

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
        backgroundColor: Theme.of(context).primaryColor,
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: contentInputController,
              decoration: InputDecoration(
                  hintText: 'Add item',
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                  prefixIcon: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 35,
                        color: Theme.of(context).primaryColor,
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
