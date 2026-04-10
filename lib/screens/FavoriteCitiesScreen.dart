import 'package:flutter/material.dart';
import '../widgets/app_button_nav.dart';

class FavoriteCitiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidades Favoritas'),
        centerTitle: true,
      ),

      body: const Center(
        child: Text("Lista de cidades favoritas"),
      ),

      bottomNavigationBar: const AppBottomNav(
        currentIndex: 0,
      ),
    );
  }
}