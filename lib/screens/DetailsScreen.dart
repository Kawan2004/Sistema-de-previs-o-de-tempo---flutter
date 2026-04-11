import 'package:flutter/material.dart';
import '../widgets/AppBottomNav.dart';

class DetailsScreen extends StatelessWidget {

  final String city = "Teresina";
  final int temp = 32;
  final String condition = "Ensolarado";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(city),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F4F1),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🌤️ CARD PRINCIPAL
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.wb_sunny, size: 60, color: Colors.orange),
                  SizedBox(height: 10),
                  Text(
                    '$temp°C',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    city,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(condition),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 📊 DETALHES (TUDO JUNTO AGORA)
            Text(
              'Detalhes do dia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            _detailCard(Icons.water_drop, 'Umidade', '70%'),
            _detailCard(Icons.air, 'Vento', '12 km/h'),
            _detailCard(Icons.thermostat, 'Sensação térmica', '34°C'),
            _detailCard(Icons.wb_sunny, 'Índice UV', '8 (Alto)'),
            _detailCard(Icons.speed, 'Pressão', '1012 hPa'),
            _detailCard(Icons.visibility, 'Visibilidade', '10 km'),
          ],
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 2,
      ),
    );
  }

  Widget _detailCard(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Text(label),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}