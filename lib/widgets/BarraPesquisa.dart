import 'dart:async';
import 'package:flutter/material.dart';

class BarraPesquisa extends StatefulWidget {
  final Function(String) onSearch;
  final Function(Map<String, dynamic>) onSelect;
  final List<Map<String, dynamic>> sugestoes;

  const BarraPesquisa({
    super.key,
    required this.onSearch,
    required this.onSelect,
    required this.sugestoes,
  });

  @override
  State<BarraPesquisa> createState() => _BarraPesquisaState();
}

class _BarraPesquisaState extends State<BarraPesquisa> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Timer? debounce;

  void onChanged(String value) {
    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 350), () {
      widget.onSearch(value);
    });
  }

  void selecionarCidade(Map<String, dynamic> cidade) {
    controller.text = cidade["name"] ?? "";

    widget.onSelect(cidade);

    _fecharBusca();
  }

  void onSubmit(String value) {
    final texto = value.trim();

    if (texto.isEmpty) return;

    if (widget.sugestoes.isNotEmpty) {
      selecionarCidade(widget.sugestoes.first);
    } else {
      widget.onSelect({"name": texto});
    }

    _fecharBusca();
  }

  void _fecharBusca() {
    widget.onSearch("");
    focusNode.unfocus();
  }

  @override
  void dispose() {
    debounce?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmit,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscar cidade...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (widget.sugestoes.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, color: Colors.black12),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.sugestoes.length,
                itemBuilder: (context, index) {
                  final cidade = widget.sugestoes[index];

                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(cidade["name"] ?? ""),
                    subtitle: Text(
                      "${cidade["admin1"] ?? ""}, ${cidade["country"] ?? ""}",
                    ),
                    onTap: () => selecionarCidade(cidade),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}