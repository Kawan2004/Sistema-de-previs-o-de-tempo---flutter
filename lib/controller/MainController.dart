import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends ChangeNotifier {
  static final MainController instance = MainController._internal();
  MainController._internal();

  // =========================
  // CLIMA PRINCIPAL
  // =========================
  Map<String, dynamic>? climaAtual;
  String cidadeAtual = "";
  bool carregando = false;

  double? latitudeAtual;
  double? longitudeAtual;

  bool _inicializado = false;

  // =========================
  // TEMPERATURA
  // =========================
  bool usarFahrenheit = false;

  double _converterTemp(double celsius) {
    if (!usarFahrenheit) return celsius;
    return (celsius * 9 / 5) + 32;
  }

  String temperatura(bool comSimbolo) {
    final tempC = (climaAtual?["temperature"] ?? 0).toDouble();
    final temp = _converterTemp(tempC).round();

    if (usarFahrenheit) {
      return comSimbolo ? "$temp°F" : "$temp";
    }

    return comSimbolo ? "$temp°C" : "$temp";
  }

  // =========================
  // FAVORITOS
  // =========================
  List<String> favoritos = [];
  Map<String, Map<String, dynamic>> cacheClima = {};
  Set<String> carregandoClima = {};

  // =========================
  // SUGESTÕES
  // =========================
  List<Map<String, dynamic>> sugestoes = [];
  bool _buscandoSugestoes = false;

  // =========================
  // INIT
  // =========================
  Future<void> iniciarApp() async {
    if (_inicializado) return;
    _inicializado = true;

    carregando = true;
    notifyListeners();

    await carregarFavoritos();

    try {
      final pos = await Geolocator.getCurrentPosition();
      await buscarClimaPorCoordenadas(pos.latitude, pos.longitude);
    } catch (_) {
      await buscarClimaPorCidade("Teresina");
    }

    carregando = false;
    notifyListeners();
  }

  // =========================
  // FAVORITOS
  // =========================
  Future<void> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    favoritos = prefs.getStringList("favoritos") ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorito(String cidade) async {
    final prefs = await SharedPreferences.getInstance();

    if (favoritos.contains(cidade)) {
      favoritos.remove(cidade);
      cacheClima.remove(cidade);
    } else {
      favoritos.add(cidade);
      buscarClimaParaFavoritos(cidade);
    }

    await prefs.setStringList("favoritos", favoritos);
    notifyListeners();
  }

  Future<void> buscarClimaParaFavoritos(String cidade) async {
    if (cacheClima.containsKey(cidade) ||
        carregandoClima.contains(cidade)) return;

    carregandoClima.add(cidade);
    notifyListeners();

    try {
      final geoUrl = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$cidade&count=1",
      );

      final geoRes = await http.get(geoUrl);
      final geoData = jsonDecode(geoRes.body);

      final geo = geoData["results"][0];

      final lat = geo["latitude"];
      final lon = geo["longitude"];

      final weatherUrl = Uri.parse(
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$lat&longitude=$lon&current_weather=true",
      );

      final weatherRes = await http.get(weatherUrl);
      final data = jsonDecode(weatherRes.body);

      cacheClima[cidade] =
          data["current_weather"] ??
          {"temperature": 0, "weathercode": 0};
    } catch (_) {
      cacheClima[cidade] = {"temperature": 0, "weathercode": 0};
    }

    carregandoClima.remove(cidade);
    notifyListeners();
  }

  Map<String, dynamic>? getClimaFavorito(String cidade) {
    return cacheClima[cidade];
  }

  // =========================
  // CLIMA PRINCIPAL
  // =========================
  Future<void> buscarClimaPorCidade(String cidade) async {
    carregando = true;
    sugestoes = [];
    notifyListeners();

    try {
      final geoUrl = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$cidade&count=1",
      );

      final geoRes = await http.get(geoUrl);
      final geoData = jsonDecode(geoRes.body);

      final geo = geoData["results"][0];

      latitudeAtual = geo["latitude"];
      longitudeAtual = geo["longitude"];
      cidadeAtual = geo["name"];

      await _buscarClima();
    } catch (_) {
      climaAtual = {"temperature": 0, "weathercode": 0};
    }

    carregando = false;
    notifyListeners();
  }

  Future<void> buscarClimaPorCoordenadas(double lat, double lon) async {
    latitudeAtual = lat;
    longitudeAtual = lon;
    await _buscarClima();
  }

  Future<void> _buscarClima() async {
    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast"
      "?latitude=$latitudeAtual&longitude=$longitudeAtual&current_weather=true",
    );

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    climaAtual = data["current_weather"];
  }

  // =========================
  // SUGESTÕES
  // =========================
  Future<void> buscarSugestoes(String texto) async {
    final query = texto.trim();

    if (query.isEmpty) {
      sugestoes = [];
      notifyListeners();
      return;
    }

    if (_buscandoSugestoes) return;
    _buscandoSugestoes = true;

    try {
      final url = Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5&language=pt",
      );

      final res = await http.get(url);
      final data = jsonDecode(res.body);

      sugestoes = List<Map<String, dynamic>>.from(data["results"] ?? []);
    } catch (_) {
      sugestoes = [];
    }

    _buscandoSugestoes = false;
    notifyListeners();
  }

  // =========================
  // HELPERS UI
  // =========================
  String descricaoClima() {
    final code = climaAtual?["weathercode"] ?? 0;

    if (code == 0) return "Céu limpo";
    if (code <= 3) return "Nublado";
    if (code <= 67) return "Chuva";
    return "Tempestade";
  }

  IconData iconeClima() {
    final code = climaAtual?["weathercode"] ?? 0;

    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 67) return Icons.umbrella;
    return Icons.flash_on;
  }
}