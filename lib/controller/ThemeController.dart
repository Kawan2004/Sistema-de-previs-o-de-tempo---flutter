import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static final ThemeController instance = ThemeController._internal();
  ThemeController._internal();

  bool _dark = false;

  bool get isDark => _dark;

  ThemeMode get themeMode =>
      _dark ? ThemeMode.dark : ThemeMode.light;

  Future<void> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    _dark = prefs.getBool("dark") ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _dark = !_dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark", _dark);

    notifyListeners();
  }
}