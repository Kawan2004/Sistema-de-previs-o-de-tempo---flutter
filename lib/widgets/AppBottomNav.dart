import 'package:flutter/material.dart';
import '../view/SettingsScreen.dart';
import '../view/MainScreen.dart';
import '../view/DetailsScreen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => _getPage(index),
          ),
        );
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configurações',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Detalhes',
        ),
      ],
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const SettingsScreen();
      case 1:
        return const MainScreen();
      case 2:
        return const DetailsScreen();
      default:
        return const MainScreen();
    }
  }
}