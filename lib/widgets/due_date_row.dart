import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DueDateRow extends StatelessWidget {
  final IconData calendarIcon;
  final String dueDateText;
  final Color dueDateColor;

  const DueDateRow(
      {Key key, this.calendarIcon, this.dueDateText, this.dueDateColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(calendarIcon, color: dueDateColor,),
          const SizedBox(
            width: 10,
          ),
          Text(
            dueDateText,
            style: TextStyle(color: dueDateColor, fontSize: 18),
          )
        ],
      );
}
