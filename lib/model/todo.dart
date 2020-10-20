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
}
