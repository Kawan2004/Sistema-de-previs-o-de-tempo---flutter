import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/AppBottomNav.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? weatherData;
  bool loading = true;
  bool isCelsius = true;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initLocation();
  }

  // 📌 CONTROLE PRINCIPAL (CORRIGIDO)
  Future<void> initLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCity = prefs.getString("last_city");

    // ✅ SE JÁ TEM CIDADE SALVA, USA E NÃO MEXE NO GPS
    if (savedCity != null && savedCity.trim().isNotEmpty) {
      fetchWeather(savedCity);
      return;
    }

    // 📍 SENÃO USA GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      fetchWeather("Teresina");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      fetchWeather("Teresina");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await getCityFromCoords(position.latitude, position.longitude);
  }

  // 🌍 GPS → cidade
  Future<void> getCityFromCoords(double lat, double lon) async {
    final url = Uri.parse(
      "https://geocoding-api.open-meteo.com/v1/reverse?latitude=$lat&longitude=$lon",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final city = (data["name"] ?? "Teresina").toString();

      fetchWeather(city);
    } else {
      fetchWeather("Teresina");
    }
  }

  // 🌦 busca cidade
  Future<Map<String, dynamic>?> getCity(String city) async {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data["results"] == null || data["results"].isEmpty) return null;
      return data["results"][0];
    }

    return null;
  }

  // 🌤 clima + SALVAR cidade
  Future<void> fetchWeather(String city) async {
    setState(() => loading = true);

    final geo = await getCity(city);

    if (geo == null) {
      setState(() => loading = false);
      return;
    }

    final lat = geo["latitude"];
    final lon = geo["longitude"];

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$lat'
      '&longitude=$lon'
      '&current_weather=true',
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      final cityName = geo["name"]?.toString() ?? city;

      setState(() {
        weatherData = {
          "city": cityName,
          "temp": data["current_weather"]["temperature"],
          "wind": data["current_weather"]["windspeed"],
        };
        loading = false;
      });

      // 💾 SALVA SEMPRE A CIDADE CORRETA
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("last_city", cityName);
    } else {
      setState(() => loading = false);
    }
  }

  String formatTemp(dynamic temp) {
    if (temp == null) return "--";

    double t = temp.toDouble();

    if (isCelsius) {
      return "${t.toStringAsFixed(0)}°C";
    } else {
      double f = (t * 9 / 5) + 32;
      return "${f.toStringAsFixed(0)}°F";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clima"),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F4F1),
      ),

      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                onSubmitted: fetchWeather,
                decoration: InputDecoration(
                  hintText: "Buscar cidade...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCelsius = !isCelsius;
                  });
                },
                child: Container(
                  width: 110,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCelsius ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("C",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCelsius
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isCelsius ? Colors.blue : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text("F",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: !isCelsius
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.wb_sunny,
                      size: 70, color: Colors.orange),

                  const SizedBox(height: 10),

                  Text(
                    loading ? "--" : formatTemp(weatherData?["temp"]),
                    style: const TextStyle(
                        fontSize: 45, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    weatherData?["city"] ?? "",
                    style: const TextStyle(fontSize: 20),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    loading
                        ? ""
                        : "Vento: ${weatherData?["wind"]} km/h",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(currentIndex: 1),
    );
  }
}