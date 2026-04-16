import 'package:flutter/material.dart';
import '../controller/MainController.dart';
import '../widgets/BarraPesquisa.dart';
import '../widgets/ClimaCard.dart';

class ClimaAba extends StatelessWidget {
  const ClimaAba({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          children: [
            // Barra de pesquisa fixa no topo
            BarraPesquisa(
              onSearch: controller.buscarSugestoes,
              sugestoes: controller.sugestoes,
              onSelect: (cidade) {
                controller.buscarClima(
                  (cidade["latitude"] as num).toDouble(),
                  (cidade["longitude"] as num).toDouble(),
                  cidade["name"],
                );
              },
            ),
            
            // O conteúdo abaixo ocupa todo o resto da tela
            Expanded(
              child: controller.carregando && controller.climaAtual == null
                  ? const Center(child: CircularProgressIndicator())
                  : ClimaCard(controller: controller),
            ),
          ],
        );
      },
    );
  }
}