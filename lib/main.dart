import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/itodo_repository.dart';
import 'repository/todo_repository.dart';
import 'screens/screens.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding();

  TodoRepository.initialize();

  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<ITodoRepository>(
      create: (_) => TodoRepository(),
    )
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(),
      home: HomeScreen(),
    );
  }
}
