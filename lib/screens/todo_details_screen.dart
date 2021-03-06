import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/todo.dart';
import '../utils/app_color_palette.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Todo todo;
  final String listTitle;
  final Future Function(Todo todo) onUpdated;
  const TodoDetailsScreen(
      {@required this.todo,
      @required this.listTitle,
      @required this.onUpdated,
      Key key})
      : super(key: key);

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  Todo todo;

  @override
  void initState() {
    super.initState();

    todo = widget.todo;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorPalette().secondaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColorPalette().textOnPrimary),
        title: Text(
          widget.listTitle,
          style: TextStyle(color: AppColorPalette().textOnPrimary),
        ),
      ),
      body: Container(
        color: AppColorPalette().containerBackgroundColor,
        alignment: Alignment.center,
        child: Column(
          children: [
            RaisedButton(
              padding: const EdgeInsets.all(16),
              onPressed: () {},
              color: AppColorPalette().secondaryColor,
              child: Row(
                children: [
                  if (todo.isComplete) _completeTodoRow(),
                  if (!todo.isComplete) _incompleteTodoRow()
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    theme: const DatePickerTheme(),
                    onConfirm: (time) async {
                      final updatedTodo = todo.copyWith(dueDate: time);

                      await widget.onUpdated(updatedTodo);

                      setState(() {
                        todo = updatedTodo;
                      });
                    },
                  );
                },
                color: AppColorPalette().secondaryColor,
                child: Container(
                  height: 70,
                  width: 365,
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      if (todo.dueDate == null) _dueDateNotSet(),
                      if (todo.dueDate != null) _dueDateSet(),
                    ],
                  ),
                ))
          ],
        ),
      ));

  Widget _dueDateSet() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.calendar_today,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            // ignore: lines_longer_than_80_chars
            'Due ${todo.dayOfWeek} ${todo.dayOfMonth} ${todo.monthOfYear}',
            style:
                TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
          ),
          IconButton(
            padding: const EdgeInsets.only(left: 20),
            icon: const Icon(
              Icons.cancel,
              color: Colors.black26,
              size: 25,
            ),
            onPressed: () async {
              final updatedTodo = todo.resetDueDate();

              await widget.onUpdated(updatedTodo);

              setState(() {
                todo = updatedTodo;
              });
            },
          )
        ],
      );

  Widget _dueDateNotSet() => Row(
        children: const [
          Icon(Icons.calendar_today),
          SizedBox(
            width: 10,
          ),
          Text('Add due date', style: TextStyle(fontSize: 18)),
        ],
      );

  Row _completeTodoRow() => Row(
        children: [
          IconButton(
              icon: Icon(
                FontAwesomeIcons.solidCheckCircle,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () async {
                final updatedTodo = todo.copyWith(isComplete: false);

                await widget.onUpdated(updatedTodo);

                setState(() {
                  todo = updatedTodo;
                });
              }),
          Text(
            widget.todo.content,
            style: const TextStyle(
                decoration: TextDecoration.lineThrough, fontSize: 24),
          ),
        ],
      );

  Row _incompleteTodoRow() => Row(
        children: [
          IconButton(
              icon: const Icon(
                FontAwesomeIcons.circle,
                size: 30,
              ),
              onPressed: () async {
                final updatedTodo = todo.copyWith(isComplete: true);

                await widget.onUpdated(updatedTodo);

                setState(() {
                  todo = updatedTodo;
                });
              }),
          if (!widget.todo.isComplete)
            Text(
              widget.todo.content,
              style: const TextStyle(fontSize: 24),
            ),
        ],
      );
}
