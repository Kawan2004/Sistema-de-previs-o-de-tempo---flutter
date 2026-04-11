import 'package:flutter/material.dart';
import '../widgets/AppBottomNav.dart';

class FavoriteCitiesScreen extends StatefulWidget {
  @override
  State<FavoriteCitiesScreen> createState() => _FavoriteCitiesScreenState();
}

class _FavoriteCitiesScreenState extends State<FavoriteCitiesScreen> {

  final TextEditingController cityController = TextEditingController();

  List<Map<String, dynamic>> favoriteCities = [
    {'city': 'Teresina', 'temp': 32, 'condition': 'Ensolarado'},
    {'city': 'São Paulo', 'temp': 25, 'condition': 'Nublado'},
    {'city': 'Rio de Janeiro', 'temp': 29, 'condition': 'Parcialmente nublado'},
  ];

  void addCity(String cityName) {
    if (cityName.trim().isEmpty) return;

    setState(() {
      favoriteCities.add({
        'city': cityName,
        'temp': 30, // valor mock (depois vem da API)
        'condition': 'Atualizando...',
      });
    });

    cityController.clear();
  }

  void showAddCityDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar cidade'),
          content: TextField(
            controller: cityController,
            decoration: InputDecoration(
              hintText: 'Ex: Fortaleza',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                addCity(cityController.text);
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidades Favoritas'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F4F1),
      ),

      body: favoriteCities.isEmpty
          ? Center(
              child: Text(
                "Nenhuma cidade favorita",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];

                return _cityCard(city, index);
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddCityDialog,
        child: Icon(Icons.add),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
      ),
    );
  }

  Widget _cityCard(Map<String, dynamic> city, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // 🌍 Cidade
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city['city'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(city['condition']),
            ],
          ),

          // 🌡️ Temp + delete
          Row(
            children: [
              Text(
                '${city['temp']}°',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  setState(() {
                    favoriteCities.removeAt(index);
                  });
                },
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}