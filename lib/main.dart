import 'package:flutter/material.dart';
import 'controller/ThemeController.dart';
import 'view/MainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeController.instance.carregarTema();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;

    return AnimatedBuilder(
      animation: theme,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clima App',

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),

          themeMode: theme.themeMode,

          home: const MainScreen(),
        );
      },
    );
  }
}