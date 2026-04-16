import 'package:flutter/material.dart';
import '../controller/MainController.dart';
import '../controller/ThemeController.dart';
import '../widgets/AppBottomNav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;
    final theme = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),
      body: AnimatedBuilder(
        animation: Listenable.merge([controller, theme]),
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Preferências", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text("Usar Fahrenheit"),
                value: controller.usarFahrenheit,
                onChanged: (v) {
                  controller.usarFahrenheit = v;
                  controller.notifyListeners();
                },
              ),
              const Divider(),
              const Text("Aparência", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: const Text("Modo Escuro"),
                value: theme.isDark,
                onChanged: (v) => theme.toggleTheme(),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}