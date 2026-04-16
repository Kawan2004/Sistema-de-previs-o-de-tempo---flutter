import 'package:flutter/material.dart';
import '../controller/MainController.dart';
import '../widgets/BarraPesquisa.dart';
import '../widgets/ClimaCard.dart';

class ClimaAba extends StatefulWidget {
  const ClimaAba({super.key});

  @override
  State<ClimaAba> createState() => _ClimaAbaState();
}

class _ClimaAbaState extends State<ClimaAba> {
  final controller = MainController.instance;

  @override
  void initState() {
    super.initState();
    controller.addListener(_update);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.iniciarApp();
    });
  }

  void _update() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carregando = controller.carregando;

    return Column(
      children: [
        BarraPesquisa(
          onSearch: controller.buscarSugestoes,
          onSelect: (cidade) {
            controller.buscarClimaPorCidade(cidade["name"]);
          },
          sugestoes: controller.sugestoes,
        ),

        const SizedBox(height: 10),

        Expanded(
          child: Center(
            child: carregando
                ? const CircularProgressIndicator()
                : ClimaCard(controller: controller),
          ),
        ),
      ],
    );
  }
}