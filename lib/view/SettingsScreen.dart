import 'package:flutter/material.dart';
import '../controller/MainController.dart';
import '../controller/ThemeController.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final controller = MainController.instance;
  final themeController = ThemeController.instance;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Configurações"),
            centerTitle: true,
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [

              const Text(
                "Clima",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text("Fahrenheit"),
                subtitle: const Text("Desligado = Celsius"),
                value: controller.usarFahrenheit,
                onChanged: (value) {
                  setState(() {
                    controller.usarFahrenheit = value;
                  });

                  controller.notifyListeners();
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Aparência",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                title: const Text("Modo escuro"),
                value: themeController.isDark,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}