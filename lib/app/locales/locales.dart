import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class AppTranslations extends Translations {
  static final Map<String, Map<String, String>> _keys = {};

  static Future<void> init() async {
    final List<String> languages = ['en_US', 'hi_IN'];
    for (var lang in languages) {
      final String jsonString = await rootBundle.loadString('assets/locales/$lang.json');
      Map<String, dynamic> map = json.decode(jsonString);
      _keys[lang] = map.map((key, value) => MapEntry(key, value.toString()));
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _keys;
}
