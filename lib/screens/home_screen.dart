import 'package:flutter/material.dart';
import 'package:flutter_todos_app/utils/localization.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(FlutterTodosAppLocalizations.of(context).translate('appBarTitle')),
      ),
      body: Center(child: Text('Todos will appear here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
