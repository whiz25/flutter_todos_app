import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isComplete;

  Todo(this.id, this.content, this.isComplete);
}
