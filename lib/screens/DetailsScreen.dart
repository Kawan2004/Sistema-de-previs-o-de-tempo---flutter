import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/AppBottomNav.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool loading = true;

  String city = "";
  Map<String, dynamic>? current;
  Map<String, dynamic>? daily;

  @override
  void initState() {
    super.initState();
    loadSavedCity();
  }

  Future<void> loadSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString("last_city") ?? "Teresina";
    fetchCityAndWeather(savedCity);
  }

  Future<void> fetchCityAndWeather(String cityName) async {
    try {
      final geoUrl = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1',
      );

      final geoRes = await http.get(geoUrl);
      final geoData = jsonDecode(geoRes.body);

      if (geoData["results"] == null || geoData["results"].isEmpty) {
        setState(() => loading = false);
        return;
      }

      final geo = geoData["results"][0];

      city = geo["name"];

      final lat = geo["latitude"];
      final lon = geo["longitude"];

      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat'
        '&longitude=$lon'
        '&current_weather=true'
        '&daily=temperature_2m_max,temperature_2m_min,weathercode'
        '&timezone=auto',
      );

      final res = await http.get(weatherUrl);
      final data = jsonDecode(res.body);

      setState(() {
        current = data["current_weather"];
        daily = data["daily"];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  String getCondition(int code) {
    if (code == 0) return "Ensolarado";
    if (code <= 3) return "Parcialmente nublado";
    if (code <= 48) return "Neblina";
    if (code <= 67) return "Chuva";
    if (code <= 77) return "Neve";
    if (code <= 82) return "Chuvas rápidas";
    return "Tempestade";
  }

  @override
  Widget build(BuildContext context) {
    final temp = current?["temperature"];
    final wind = current?["windspeed"];
    final code = current?["weathercode"];

    return Scaffold(
      appBar: AppBar(
        title: Text(city.isEmpty ? "Detalhes" : city),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    temp != null ? "$temp°C" : "--",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(city),

                  const SizedBox(height: 5),

                  Text(
                    code != null ? getCondition(code) : "Sem dados",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Detalhes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  _row("Vento", wind != null ? "$wind km/h" : "--"),
                  _row("Sensação", temp != null ? "$temp°C" : "--"),

                  const SizedBox(height: 20),

                  const Text(
                    "Próximos dias",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: daily == null
                        ? const Text("Sem previsão")
                        : ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: const Icon(Icons.wb_sunny),
                                title: Text("Dia ${i + 1}"),
                                trailing: Text(
                                  "${daily!["temperature_2m_max"][i]}° / ${daily!["temperature_2m_min"][i]}°",
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

      bottomNavigationBar: AppBottomNav(currentIndex: 2),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}