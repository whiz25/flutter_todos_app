import 'package:flutter/material.dart';
import 'package:flutter_todos_app/utils/app_color_palette.dart';

ThemeData appTheme() {
  return ThemeData.light().copyWith(
      primaryColor: AppColorPalette().primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColorPalette().primaryColorDark),
      textTheme: _appTextTheme());
}

TextTheme _appTextTheme() {
  return TextTheme(
      bodyText2:
          TextStyle(color: AppColorPalette().textOnPrimary, fontSize: 18.0));
}
