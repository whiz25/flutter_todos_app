import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/todo.dart';
import '../utils/app_color_palette.dart';
import '../utils/localization.dart';
import '../widgets/widgets.dart';

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
            style:
                TextStyle(color: AppColorPalette().textOnPrimary, fontSize: 24),
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
                  onPressed: () async {
                    final DateTime pickedDateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050));

                    if (pickedDateTime != null) {
                      final updatedTodo = todo.copyWith(
                          dueDate: pickedDateTime, createdOn: todo.createdOn);

                      await widget.onUpdated(updatedTodo);

                      setState(() {
                        todo = updatedTodo;
                      });
                    }
                  },
                  color: AppColorPalette().secondaryColor,
                  child: Container(
                    height: 70,
                    width: 365,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        if (todo.dueDate == null) _dueDateNotSet,
                        if (todo.dueDate != null) _dueDateSet,
                      ],
                    ),
                  ))
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (todo.completedOn == null) _createdOn(),
                if (todo.completedOn != null) _completedOn(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.trashAlt),
                )
              ],
            ),
          ),
        ),
      );
  Widget _createdOn() => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
            // ignore: lines_longer_than_80_chars
            'Created on ${todo.dayOfWeek(todo.createdOn)} ${todo.dayOfMonth(todo.createdOn)} ${todo.monthOfYear(todo.createdOn)}'),
      );

  Widget _completedOn() => Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
            // ignore: lines_longer_than_80_chars
            'Completed on ${todo.dayOfWeek(todo.completedOn)} ${todo.dayOfMonth(todo.completedOn)} ${todo.monthOfYear(todo.completedOn)}'),
      );

  Widget get _dueDateSet => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (todo.isDueDateExpired) _dueDateExpired,
          if (!todo.isDueDateExpired) _dueDateNotExpired,
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

  Widget get _dueDateExpired => DueDateRow(
        calendarIcon: Icons.calendar_today,
        dueDateText:
            // ignore: lines_longer_than_80_chars
            'Due ${todo.dayOfWeek(todo.dueDate)} ${todo.dayOfMonth(todo.dueDate)} ${todo.monthOfYear(todo.dueDate)}',
        dueDateColor: AppColorPalette().expiredDueDateColor,
      );

  Widget get _dueDateNotExpired => DueDateRow(
        calendarIcon: Icons.calendar_today,
        dueDateText:
            // ignore: lines_longer_than_80_chars
            'Due ${todo.dayOfWeek(todo.dueDate)} ${todo.dayOfMonth(todo.dueDate)} ${todo.monthOfYear(todo.dueDate)}',
        dueDateColor: Theme.of(context).primaryColor,
      );

  Widget get _dueDateNotSet => Row(
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(
            width: 10,
          ),
          Text(
              // ignore: lines_longer_than_80_chars
              '${FlutterTodosAppLocalizations.of(context).translate("add_due_date")}',
              style: const TextStyle(fontSize: 18)),
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
                final resetTodo = todo.resetCompletedDate();
                final updatedTodo = todo.copyWith(
                    isComplete: false, completedOn: resetTodo.completedOn);

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
                final updatedTodo = todo.copyWith(
                    isComplete: true, completedOn: DateTime.now());

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
