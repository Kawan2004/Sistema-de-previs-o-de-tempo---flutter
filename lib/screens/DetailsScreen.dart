import 'package:flutter/material.dart';
import '../widgets/app_button_nav.dart';

class DetailsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("cidade"),
        centerTitle: true,
      ),

      body: Center(
        child: Text("Detalhes do clima"),
      ),

      bottomNavigationBar: const AppBottomNav(
        currentIndex: 2,
      ),
    );
  }
}