import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String content;

  @HiveField(1)
  bool isComplete;

  Todo({this.content, this.isComplete=false});
}
