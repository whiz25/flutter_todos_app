import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FlutterTodosAppLocalizations {
  final Locale locale;

  FlutterTodosAppLocalizations(this.locale);

  static FlutterTodosAppLocalizations of(BuildContext context) =>
   Localizations.of<FlutterTodosAppLocalizations>(
        context, FlutterTodosAppLocalizations);

  static const LocalizationsDelegate<FlutterTodosAppLocalizations> delegate =
      _FlutterTodosAppLocalizationsDelegate();

  Map<dynamic, dynamic> _localizedStrings;

  Future<bool> load() async {
    final String jsonString = await rootBundle
        .loadString('assets/localization/${locale.languageCode}.json');

    final dynamic jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((dynamic key, dynamic value) => 
        MapEntry<dynamic, dynamic>(key, value.toString()))
         as Map<dynamic, dynamic>;
    return true;
  }

  dynamic translate(String key) => _localizedStrings[key];
}

class _FlutterTodosAppLocalizationsDelegate
    extends LocalizationsDelegate<FlutterTodosAppLocalizations> {
  const _FlutterTodosAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'da'].contains(locale.languageCode);

  @override
  Future<FlutterTodosAppLocalizations> load(Locale locale) async {
    final FlutterTodosAppLocalizations localizations =
        FlutterTodosAppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_FlutterTodosAppLocalizationsDelegate old) => false;
}
