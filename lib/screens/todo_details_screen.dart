import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_todos_app/blocs/todo_state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mdi/mdi.dart';
import '../blocs/todo_bloc.dart';
import '../model/todo.dart';
import '../model/todo_list.dart';
import '../repository/itodo_repository.dart';
import '../utils/app_color_palette.dart';

class TodoDetailsScreen extends StatefulWidget {
  final Todo todo;
  final TodoList todoList;
  final TodoBloc todoBloc;

  const TodoDetailsScreen({Key key, this.todo, this.todoList, this.todoBloc})
      : super(key: key);

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  TodoBloc todoBloc;
  TodoState todoBlocState;

  @override
  void initState() {
    super.initState();

    todoBloc = TodoBloc(
        todoList: widget.todoList,
        iTodoRepository: RepositoryProvider.of<ITodoRepository>(context));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  if (widget.todo.isComplete)
                    Text(
                      widget.todo.content,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough, fontSize: 20),
                    ),
                  if (!widget.todo.isComplete)
                    Text(
                      widget.todo.content,
                      style: const TextStyle(fontSize: 20),
                    ),
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
            icon: const Icon(Icons.cancel),
            onPressed: () {},
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
}
