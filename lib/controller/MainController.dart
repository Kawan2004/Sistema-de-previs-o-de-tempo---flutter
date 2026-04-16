import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainController extends ChangeNotifier {
  static final MainController instance = MainController._internal();
  MainController._internal();

  Map<String, dynamic>? climaAtual;
  List<dynamic> previsaoSeteDias = [];
  String cidadeAtual = "Localizando...";
  bool carregando = false;
  
  double? latitudeAtual;
  double? longitudeAtual;
  List<Map<String, dynamic>> sugestoes = [];
  List<String> favoritos = [];
  bool usarFahrenheit = false;

  Future<void> iniciarApp() async {
    await carregarFavoritos();
    await obterLocalizacaoAtual();
  }

  Future<void> obterLocalizacaoAtual() async {
    carregando = true;
    notifyListeners();
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition();
      await buscarClima(position.latitude, position.longitude, "Minha Localização");
    } catch (e) {
      cidadeAtual = "Localização Indisponível";
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> buscarClima(double lat, double lon, [String? nomeCidade]) async {
    latitudeAtual = lat;
    longitudeAtual = lon;
    if (nomeCidade != null) cidadeAtual = nomeCidade;
    sugestoes = []; // Fecha a lista de pesquisa
    carregando = true;
    notifyListeners();

    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon"
      "&current_weather=true&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"
    );

    try {
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      climaAtual = data["current_weather"];
      final daily = data["daily"];
      previsaoSeteDias = List.generate(daily["time"].length, (i) => {
        "dia": daily["time"][i],
        "max": daily["temperature_2m_max"][i],
        "min": daily["temperature_2m_min"][i],
        "code": daily["weathercode"][i],
      });
    } catch (e) {
      debugPrint("Erro: $e");
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  String temperatura(bool comSimbolo) {
    if (climaAtual == null) return "--";
    double temp = (climaAtual!["temperature"] as num).toDouble();
    if (usarFahrenheit) temp = (temp * 9 / 5) + 32;
    String valor = temp.round().toString();
    return comSimbolo ? "$valor°${usarFahrenheit ? "F" : "C"}" : valor;
  }

  String descricaoClima([int? code]) {
    int c = code ?? (climaAtual?["weathercode"] ?? 0);
    if (c == 0) return "Céu Limpo";
    if (c <= 3) return "Nublado";
    if (c <= 67) return "Chuva Leve";
    return "Trovoada";
  }

  IconData iconeClima([int? code]) {
    int c = code ?? (climaAtual?["weathercode"] ?? 0);
    if (c == 0) return Icons.wb_sunny;
    if (c <= 3) return Icons.wb_cloudy;
    return Icons.umbrella;
  }

  Future<void> carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    favoritos = prefs.getStringList("favs") ?? [];
    notifyListeners();
  }

  void toggleFavorito(String cidade) async {
    if (cidade.isEmpty) return;
    favoritos.contains(cidade) ? favoritos.remove(cidade) : favoritos.add(cidade);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favs", favoritos);
    notifyListeners();
  }

  Future<void> buscarSugestoes(String text) async {
    if (text.trim().isEmpty) { sugestoes = []; notifyListeners(); return; }
    final url = Uri.parse("https://geocoding-api.open-meteo.com/v1/search?name=$text&count=5&language=pt");
    try {
      final res = await http.get(url);
      final data = jsonDecode(res.body);
      sugestoes = List<Map<String, dynamic>>.from(data["results"] ?? []);
    } catch (_) { sugestoes = []; }
    notifyListeners();
  }
}