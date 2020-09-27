import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Flutter Todos App'),
      ),
      body: Center(child: Text('Todos will appear here')),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},child: Icon(Icons.add),
        ),
    );
  }
}
