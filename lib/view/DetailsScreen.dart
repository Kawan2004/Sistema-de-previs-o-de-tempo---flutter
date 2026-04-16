import 'package:flutter/material.dart';
import '../controller/MainController.dart';
import '../widgets/AppBottomNav.dart';
import '../widgets/ClimaCard.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController.instance;

    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              // Cabeçalho com o ClimaCard (Design Original)
              SliverToBoxAdapter(
                child: ClimaCard(controller: controller),
              ),

              // Título da Seção
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
                  child: Text(
                    "Previsão Semanal",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Bloco Único com todos os dias
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: List.generate(controller.previsaoSeteDias.length, (index) {
                        final dia = controller.previsaoSeteDias[index];
                        final bool isUltimo = index == controller.previsaoSeteDias.length - 1;

                        return Column(
                          children: [
                            _buildDayRow(dia, controller),
                            // Adiciona uma linha divisória, exceto no último item
                            if (!isUltimo)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(color: Colors.blue.withOpacity(0.1), height: 1),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  // Widget que desenha a linha de cada dia
  Widget _buildDayRow(Map<String, dynamic> dia, MainController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // Dia da semana
          Expanded(
            flex: 2,
            child: Text(
              dia["dia"],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          // Ícone e Descrição
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(c.iconeClima(dia["code"]), size: 22, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                Text(
                  c.descricaoClima(dia["code"]),
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          // Temperaturas
          Text(
            "${dia["max"].round()}° / ${dia["min"].round()}°",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}