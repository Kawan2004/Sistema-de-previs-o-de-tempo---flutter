import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/AppBottomNav.dart';

class FavoriteCitiesScreen extends StatefulWidget {
  @override
  State<FavoriteCitiesScreen> createState() => _FavoriteCitiesScreenState();
}

class _FavoriteCitiesScreenState extends State<FavoriteCitiesScreen> {
  final TextEditingController cityController = TextEditingController();

  List<Map<String, dynamic>> favoriteCities = [];

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  // HTTP SEGURO
  Future<http.Response?> safeGet(Uri url) async {
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Erro HTTP: $e");
      return null;
    }
  }

  // 💾 salvar
  Future<void> saveCities() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('cities', jsonEncode(favoriteCities));
  }

  // carregar
  Future<void> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('cities');

    if (data != null) {
      final List decoded = jsonDecode(data);

      setState(() {
        favoriteCities = decoded.cast<Map<String, dynamic>>();
      });
    }
  }

  //  geocoding
  Future<Map<String, dynamic>?> getCity(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1',
    );

    final res = await safeGet(url);
    if (res == null) return null;

    final data = jsonDecode(res.body);

    if (data["results"] == null || data["results"].isEmpty) {
      return null;
    }

    return data["results"][0];
  }

  // 🌤️ clima
  Future<Map<String, dynamic>?> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat'
      '&longitude=$lon'
      '&current_weather=true',
    );

    final res = await safeGet(url);
    if (res == null) return null;

    final data = jsonDecode(res.body);

    return data["current_weather"];
  }

  Future<void> addCity(String cityName) async {
    if (cityName.trim().isEmpty) return;

    Navigator.pop(context);

    final geo = await getCity(cityName);
    if (geo == null) return;

    final weather = await getWeather(
      geo["latitude"],
      geo["longitude"],
    );

    if (weather == null) return;

    setState(() {
      favoriteCities.add({
        "city": geo["name"],
        "temp": weather["temperature"],
      });
    });

    await saveCities();
    cityController.clear();
  }

  void removeCity(int index) async {
    setState(() {
      favoriteCities.removeAt(index);
    });

    await saveCities();
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
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => addCity(cityController.text),
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

          // 🌍 cidade
          Text(
            city["city"],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          // 🌡️ temperatura
          Row(
            children: [
              Text(
                "${city["temp"]}°",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(width: 10),

              GestureDetector(
                onTap: () => removeCity(index),
                child: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}