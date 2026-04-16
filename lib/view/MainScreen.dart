import 'package:flutter/material.dart';
import '../widgets/AppBottomNav.dart';
import 'ClimaAba.dart';
import 'FavoritoAba.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Clima"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Clima"),
              Tab(text: "Favoritos"),
            ],
          ),
        ),

        body: const TabBarView(
          children: [
            ClimaAba(),
            FavoritosAba(),
          ],
        ),

        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      ),
    );
  }
}