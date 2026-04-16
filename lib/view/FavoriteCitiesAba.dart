import 'package:flutter/material.dart';

class FavoritosAba extends StatelessWidget {
  const FavoritosAba({super.key});

  void _onAddPressed() {
    // futura ação
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🌤 AppBar com botão no canto superior direito
      appBar: AppBar(
        title: const Text("Cidades Favoritas"),
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12), // 👈 afasta da borda
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _onAddPressed,
            ),
          ),
        ],
      ),

      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              Icons.location_city,
              size: 60,
              color: Colors.grey,
            ),

            SizedBox(height: 12),

            Text(
              "Nenhuma cidade favorita",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}