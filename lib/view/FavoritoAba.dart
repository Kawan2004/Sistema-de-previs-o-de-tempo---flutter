import 'package:flutter/material.dart';
import '../controller/MainController.dart';

class FavoritosAba extends StatefulWidget {
  const FavoritosAba({super.key});

  @override
  State<FavoritosAba> createState() => _FavoritosAbaState();
}

class _FavoritosAbaState extends State<FavoritosAba> {
  final controller = MainController.instance;

  @override
  void initState() {
    super.initState();

    controller.addListener(_update);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.carregarFavoritos();

      for (final cidade in controller.favoritos) {
        controller.buscarClimaParaFavoritos(cidade);
      }
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
    final favoritos = controller.favoritos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cidades Favoritas"),
        centerTitle: true,
      ),

      body: favoritos.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_city, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    "Nenhuma cidade favorita",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final cidade = favoritos[index];
                final clima = controller.getClimaFavorito(cidade);
                final carregando =
                    controller.carregandoClima.contains(cidade);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(cidade),

                    subtitle: carregando
                        ? const Text("Carregando...")
                        : Text(
                            clima == null
                                ? "Sem dados"
                                : "${clima["temperature"]}° • código ${clima["weathercode"]}",
                          ),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.toggleFavorito(cidade);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}