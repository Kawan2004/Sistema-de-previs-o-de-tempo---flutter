import 'package:flutter/material.dart';

class BarraPesquisa extends StatelessWidget {
  final Function(String) onSearch;
  final Function(Map<String, dynamic>) onSelect;
  final List<Map<String, dynamic>> sugestoes;

  const BarraPesquisa({super.key, required this.onSearch, required this.onSelect, required this.sugestoes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: "Buscar cidade...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          if (sugestoes.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: Column(
                children: sugestoes.map((c) => ListTile(
                  title: Text(c["name"]),
                  subtitle: Text("${c["admin1"]}, ${c["country"]}"),
                  onTap: () => onSelect(c),
                )).toList(),
              ),
            )
        ],
      ),
    );
  }
}