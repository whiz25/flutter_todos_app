import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_todos_app/utils/localization.dart';
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
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: HomeScreen(),
      supportedLocales: [Locale('en', 'US'), Locale('da', 'DK')],
      localizationsDelegates: [FlutterTodosAppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
    );
  }
}
