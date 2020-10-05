import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'todo.dart';

part 'todo_list.g.dart';

@HiveType(typeId: 1)
class TodoList extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<Todo> todos;

  TodoList({@required this.title});
}
