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
    controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    controller.removeListener(_rebuild);
    super.dispose();
  }

  // Corrigido: Sintaxe da função anônima
  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = controller.favoritos;

    return Scaffold(
      backgroundColor: Colors.transparent, // Permite ver o fundo se houver gradiente no Main
      body: favoritos.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final cidade = favoritos[index];
                return _buildFavoritoCard(cidade);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: Colors.blue.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Sua lista está vazia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade900.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Adicione cidades para acompanhar\no clima rapidamente.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritoCard(String cidade) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.location_city, color: Colors.blue),
          ),
          title: Text(
            cidade,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: const Text("Toque para ver detalhes"),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () => controller.toggleFavorito(cidade),
          ),
          onTap: () {
            // Ação opcional: buscar clima e ir para Detalhes
            // controller.buscarClimaPorCidade(cidade);
          },
        ),
      ),
    );
  }
}