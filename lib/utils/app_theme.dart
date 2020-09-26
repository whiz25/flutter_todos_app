import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData.light().copyWith(
    textTheme: _appTextTheme()
  );
}

TextTheme _appTextTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: Colors.black)
  );
}
