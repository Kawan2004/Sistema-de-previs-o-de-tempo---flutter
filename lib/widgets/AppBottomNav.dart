import 'package:flutter/material.dart';
import '../view/SettingsScreen.dart';
import '../view/MainScreen.dart';
import '../view/DetailsScreen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  void _nav(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (i == 0) _nav(context, const SettingsScreen());
        if (i == 1) _nav(context, const MainScreen());
        if (i == 2) _nav(context, const DetailsScreen());
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Detalhes"),
      ],
    );
  }
}