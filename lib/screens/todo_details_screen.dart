import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/todo_bloc.dart';
import '../blocs/todo_state.dart';
import '../model/todo.dart';
import '../model/todo_list.dart';
import '../utils/app_color_palette.dart';
import '../widgets/widgets.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Todo todo;
  final TodoList todoList;
  final TodoBloc todoBloc;
  final TodoState todoState;
  final int index;
  final GlobalKey<AnimatedListState> incompleteTodoListKey;
  final GlobalKey<AnimatedListState> completeTodoListKey;

  const TodoDetailsScreen(
      {Key key,
      this.todo,
      this.todoList,
      this.todoBloc,
      this.todoState,
      this.index,
      this.incompleteTodoListKey,
      this.completeTodoListKey})
      : super(key: key);

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  @override
  Widget build(BuildContext context) => BlocBuilder<TodoBloc, TodoState>(
      cubit: widget.todoBloc,
      builder: (context, state) {
        if (state == null) {
          return const ProgressLoader();
        }
        return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColorPalette().secondaryColor,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColorPalette().textOnPrimary),
              title: Text(
                widget.todoList.title,
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
                        if (widget.todo.isComplete) _completeTodoRow(),
                        if (!widget.todo.isComplete) _incompleteTodoRow()
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
                            widget.todo.dueDate = time;

                            await widget.todoBloc.update(widget.todo);
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
                            if (widget.todo.dueDate == null) _dueDateNotSet(),
                            if (widget.todo.dueDate != null) _dueDateSet(),
                          ],
                        ),
                      ))
                ],
              ),
            ));
      });

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
            'Due ${widget.todoBloc.dayOfWeek(widget.todo)} ${widget.todoBloc.dayOfMonth(widget.todo)} ${widget.todoBloc.monthOfYear(widget.todo)}',
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
              widget.todo.dueDate = null;

              await widget.todoBloc.update(widget.todo);
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
                widget.completeTodoListKey.currentState.removeItem(
                    widget.index,
                    (context, animation) => const SizedBox(
                          width: 0,
                          height: 0,
                        ));

                await widget.todoBloc.completeTodo(widget.todo);

                widget.incompleteTodoListKey.currentState.insertItem(0);
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
                widget.incompleteTodoListKey.currentState.removeItem(
                    widget.index,
                    (context, animation) => const SizedBox(
                          width: 0,
                          height: 0,
                        ));

                await widget.todoBloc.completeTodo(widget.todo);

                widget.completeTodoListKey.currentState.insertItem(0);
              }),
          if (!widget.todo.isComplete)
            Text(
              widget.todo.content,
              style: const TextStyle(fontSize: 24),
            ),
        ],
      );
}
