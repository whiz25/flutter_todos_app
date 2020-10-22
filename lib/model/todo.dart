import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String content;

  @HiveField(2)
  bool isComplete;

  @HiveField(3)
  DateTime dueDate;

  Todo(
      {@required this.id,
      @required this.content,
      this.isComplete = false,
      this.dueDate});

  Todo copyWith(
          {String id, String content, bool isComplete, DateTime dueDate}) =>
      Todo(
          id: id ?? this.id,
          content: content ?? this.content,
          isComplete: isComplete ?? this.isComplete,
          dueDate: dueDate ?? this.dueDate);
}
