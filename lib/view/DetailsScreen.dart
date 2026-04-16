import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../controller/MainController.dart';
import '../widgets/AppBottomNav.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final MainController c = MainController.instance;

  List<Map<String, dynamic>> previsao = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    c.addListener(_update);
    _buscarPrevisao();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    c.removeListener(_update);
    super.dispose();
  }

  Future<void> _buscarPrevisao() async {
    final lat = c.latitudeAtual;
    final lon = c.longitudeAtual;

    if (lat == null || lon == null) return;

    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast"
      "?latitude=$lat"
      "&longitude=$lon"
      "&daily=temperature_2m_max,temperature_2m_min"
      "&timezone=auto",
    );

    try {
      final res = await http.get(url);
      final data = jsonDecode(res.body);

      final dias = data["daily"];

      final List<String> datas = List<String>.from(dias["time"]);
      final List max = dias["temperature_2m_max"];
      final List min = dias["temperature_2m_min"];

      previsao = List.generate(datas.length, (i) {
        return {
          "dia": _formatarDia(datas[i]),
          "tempMax": max[i].round(),
          "tempMin": min[i].round(),
        };
      });

      setState(() {
        carregando = false;
      });
    } catch (_) {
      setState(() {
        carregando = false;
      });
    }
  }

  String _formatarDia(String data) {
    final d = DateTime.parse(data);
    const dias = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"];
    return dias[d.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text("Detalhes"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CARD
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF87CEEB), Color(0xFF5DADE2)],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                Icon(c.iconeClima(), size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  c.temperatura(true),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  c.descricaoClima(),
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                Text(
                  c.cidadeAtual,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Previsão (7 dias)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (carregando)
            const Center(child: CircularProgressIndicator()),

          if (!carregando)
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: previsao.length,
                itemBuilder: (context, index) {
                  final d = previsao[index];

                  return Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(d["dia"]),
                        const SizedBox(height: 10),
                        Text("Máx ${d["tempMax"]}°"),
                        Text("Mín ${d["tempMin"]}°"),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}