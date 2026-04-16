import 'package:flutter/material.dart';
import '../controller/MainController.dart';

class ClimaCard extends StatelessWidget {
  final MainController controller;
  const ClimaCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isFavorita = controller.favoritos.contains(controller.cidadeAtual);

    return Container(
      width: double.infinity,
      // Removemos o height fixo e deixamos o padding ditar o tamanho
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFF5DADE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min, // Faz o container se ajustar ao conteúdo
            crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento original à esquerda
            children: [
              Text(
                controller.cidadeAtual,
                style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.temperatura(true),
                    style: const TextStyle(fontSize: 60, color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(width: 20),
                  Icon(controller.iconeClima(), size: 60, color: Colors.white),
                ],
              ),
              Text(
                controller.descricaoClima(),
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 5),
              Text(
                "Vento: ${controller.climaAtual?['windspeed'] ?? 0} km/h",
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                isFavorita ? Icons.favorite : Icons.favorite_border,
                color: isFavorita ? Colors.red : Colors.white,
              ),
              onPressed: () => controller.toggleFavorito(controller.cidadeAtual),
            ),
          ),
        ],
      ),
    );
  }
}