import 'package:flutter/material.dart';
import '../screens/homeScreen.dart';
import '../screens/favoriteCitiesScreen.dart';
import '../screens/detailsScreen.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget page;

    switch (index) {
      case 0:
        page = FavoriteCitiesScreen();
        break;
      case 1:
        page = HomeScreen();
        break;
      case 2:
        page = DetailsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoritas',
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
}