import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isComplete;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final DateTime createdAt;

  Todo(
      {@required this.id,
      @required this.content,
      this.isComplete = false,
      this.dueDate,
      this.createdAt});

  Todo copyWith(
          {String id, String content, bool isComplete, DateTime dueDate}) =>
      Todo(
          id: id ?? this.id,
          content: content ?? this.content,
          isComplete: isComplete ?? this.isComplete,
          dueDate: dueDate ?? this.dueDate);

  Todo resetDueDate() => Todo(
        id: id,
        content: content,
        isComplete: isComplete,
      );

  String get dayOfWeek {
    final int day = dueDate.weekday;
    switch (day) {
      case 1:
        return 'Mon';
        break;
      case 2:
        return 'Tue';
        break;
      case 3:
        return 'Wed';
        break;
      case 4:
        return 'Thu';
        break;
      case 5:
        return 'Fri';
        break;
      case 6:
        return 'Sat';
        break;
      case 7:
        return 'Sun';
        break;
      default:
        return 'Mon';
        break;
    }
  }

  String get monthOfYear => DateFormat.MMM().format(dueDate);

  String get dayOfMonth => DateFormat.d().format(dueDate);

  bool get isDueDateExpired {
    final timeNow = DateTime.now();
    return timeNow.isAfter(dueDate);
  }
}
