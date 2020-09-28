import 'package:flutter/material.dart';
import 'app_color_palette.dart';

ThemeData appTheme() => ThemeData(
    primaryColor: AppColorPalette().primaryColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorPalette().primaryColorDark),
    textTheme: _appTextTheme());

TextTheme _appTextTheme() =>
    const TextTheme(bodyText2: TextStyle(fontSize: 18));
