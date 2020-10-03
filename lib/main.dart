import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'repository/itodo_repository.dart';
import 'repository/todo_repository.dart';
import 'screens/screens.dart';
import 'utils/app_theme.dart';
import 'utils/localization.dart';

void main() {
  WidgetsFlutterBinding();

  TodoRepository.initialize();

  runApp(MultiRepositoryProvider(providers: [
    RepositoryProvider<ITodoRepository>(
      create: (_) => TodoRepository(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(),
        home: const HomeScreen(),
        supportedLocales: const [Locale('en', 'US'), Locale('da', 'DK')],
        localizationsDelegates: const [
          FlutterTodosAppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      );
}
