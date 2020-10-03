import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos_app/repository/itodo_repository.dart';
import 'package:flutter_todos_app/repository/todo_repository.dart';

Widget buildTestMain(Widget child,
        {RepositoryProvider<ITodoRepository> repositoryProvider}) =>
    MultiRepositoryProvider(
      providers: [
        repositoryProvider ??
            RepositoryProvider<ITodoRepository>(
              create: (_) => TodoRepository(),
            )
      ],
      child: MaterialApp(
        home: child,
      ),
    );
