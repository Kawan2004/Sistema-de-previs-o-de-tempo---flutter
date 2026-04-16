import 'package:flutter/material.dart';
import '../controller/MainController.dart';

class ClimaCard extends StatelessWidget {
  final MainController controller;

  const ClimaCard({super.key, required this.controller});

  bool get _isFavorita =>
      controller.favoritos.contains(controller.cidadeAtual);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF87CEEB), Color(0xFF5DADE2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                color: Colors.black.withOpacity(0.10),
                offset: const Offset(0, 6),
              ),
            ],
          ),

          // 🔥 IMPORTANTE: Stack só para o botão, NÃO para layout
          child: Stack(
            children: [

              // =========================
              // CONTEÚDO ORIGINAL (INTACTO)
              // =========================
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          controller.iconeClima(),
                          size: 60,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          controller.temperatura(true),
                          style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          controller.descricaoClima(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 1,
                    height: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          controller.cidadeAtual.isNotEmpty
                              ? controller.cidadeAtual
                              : "--",
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Brasil",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // =========================
              // ❤️ BOTÃO FAVORITO (SÓ OVERLAY)
              // =========================
              Positioned(
                top: -8,
                right: -8,
                child: IconButton(
                  icon: Icon(
                    _isFavorita
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    if (controller.cidadeAtual.isEmpty) return;
                    controller.toggleFavorito(controller.cidadeAtual);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}