import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FlutterTodosAppLocalizations {
  final Locale locale;

  FlutterTodosAppLocalizations(this.locale);

  static FlutterTodosAppLocalizations of(BuildContext context) {
    return Localizations.of<FlutterTodosAppLocalizations>(
        context, FlutterTodosAppLocalizations);
  }

  static const LocalizationsDelegate<FlutterTodosAppLocalizations> delegate =
      _FlutterTodosAppLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle
        .loadString('assets/localization/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key];
  }
}

class _FlutterTodosAppLocalizationsDelegate
    extends LocalizationsDelegate<FlutterTodosAppLocalizations> {
  const _FlutterTodosAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'da'].contains(locale.languageCode);
  }

  @override
  Future<FlutterTodosAppLocalizations> load(Locale locale) async {
    FlutterTodosAppLocalizations localizations =
        FlutterTodosAppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_FlutterTodosAppLocalizationsDelegate old) => false;
}
