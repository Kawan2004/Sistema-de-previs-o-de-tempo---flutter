import 'package:flutter/material.dart';
import '../widgets/app_button_nav.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do tempo'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F4F1),
      ),

      body: const Center(
        child: Text("Home - clima atual"),
      ),

      bottomNavigationBar: const AppBottomNav(
        currentIndex: 1,
      ),
    );
  }
}