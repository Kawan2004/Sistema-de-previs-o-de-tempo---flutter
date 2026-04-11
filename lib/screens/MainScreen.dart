import 'package:flutter/material.dart';
import '../widgets/AppBottomNav.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isCelsius = true;
  double selectedDays = 7;

  final List<Map<String, dynamic>> forecast = [
    {'day': 'Seg', 'tempC': 33},
    {'day': 'Ter', 'tempC': 30},
    {'day': 'Qua', 'tempC': 28},
    {'day': 'Qui', 'tempC': 31},
    {'day': 'Sex', 'tempC': 29},
    {'day': 'Sáb', 'tempC': 32},
    {'day': 'Dom', 'tempC': 30},
  ];

  String formatTemp(int tempC) {
    if (isCelsius) return '$tempC°';
    double f = (tempC * 9 / 5) + 32;
    return '${f.toStringAsFixed(0)}°';
  }

  List<Map<String, dynamic>> get visibleForecast {
    return forecast.take(selectedDays.toInt()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do tempo'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F4F1),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔍 BUSCA
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar cidade...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // 🌤️ CARD PRINCIPAL
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [

                    // 🔲 TOGGLE °C / °F
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isCelsius = !isCelsius;
                          });
                        },
                        child: Container(
                          width: 42,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            isCelsius ? '°C' : '°F',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    // 🌤️ CONTEÚDO CENTRALIZADO
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wb_sunny,
                              size: 60, color: Colors.orange),
                          SizedBox(height: 10),
                          Text(
                            isCelsius ? '32°C' : '90°F',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Teresina - PI',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 10),
                          Text('Ensolarado'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // 📅 TÍTULO
              Text(
                'Próximos dias',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              // 📊 PREVISÃO
              Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: visibleForecast.map((item) {
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            item['day'],
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 6),
                          Text(
                            formatTemp(item['tempC']),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 20),

              // 🎚 SLIDER
              Text(
                'Quantidade de dias: ${selectedDays.toInt()}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              SizedBox(
                width: double.infinity,
                child: Slider(
                  value: selectedDays,
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: selectedDays.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      selectedDays = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
      ),
    );
  }
}