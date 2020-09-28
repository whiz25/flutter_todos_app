import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  const ProgressLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: const Center(child: CircularProgressIndicator()),
    );
}
