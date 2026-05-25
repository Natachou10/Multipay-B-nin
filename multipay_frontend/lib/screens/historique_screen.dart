import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  List<dynamic> _historique = [];
  bool _isLoading = true;
  String _filtreType = 'tous';
  final TextEditingController _searchController = TextEditingController();

  final Color primaryGreen = const Color(0xFF78B596);

  @override
  void initState() {
    super.initState();
    _chargerHistorique();
  }

  Future<void> _chargerHistorique() async {
    setState(() => _isLoading = true);
    final data = await ApiService.consulterHistorique(
      type: _filtreType == 'tous' ? null : _filtreType
    );
    setState(() {
      _historique = data['historique'] ?? [];
      _isLoading = false;
    });
  }

  Color _couleurType(String type) {
    switch (type) {
      case 'depot': return Colors.green;
      case 'retrait': return Colors.red;
      case 'credit': return Colors.orange;
      case 'forfait': return Colors.blue;
      case 'sbee': return Colors.yellow.shade800;
      case 'soneb': return Colors.cyan;
      case 'canal': return Colors.purple;
      case 'scolarite': return Colors.teal;
      default: return Colors.grey;
    }
  }

  IconData _iconeType(String type) {
    switch (type) {
      case 'depot': return Icons.arrow_downward;
      case 'retrait': return Icons.arrow_upward;
      case 'credit': return Icons.phone_android;
      case 'forfait': return Icons.wifi;
      case 'sbee': return Icons.electric_bolt;
      case 'soneb': return Icons.water_drop;
      case 'canal': return Icons.tv;
      case 'scolarite': return Icons.school;
      default: return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredHistorique = _historique.where((item) {
      final search = _searchController.text.toLowerCase();
      if (search.isEmpty) return true;
      return item['description'].toString().toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      appBar: AppBar(
        title: const Text('Historique', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Rechercher un numéro ou une réf...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Filtres
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['tous', 'depot', 'retrait', 'credit', 'forfait', 'sbee', 'soneb', 'canal', 'scolarite']
                  .map((type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type.toUpperCase()),
                      selected: _filtreType == type,
                      onSelected: (_) {
                        setState(() => _filtreType = type);
                        _chargerHistorique();
                      },
                      selectedColor: primaryGreen,
                      labelStyle: TextStyle(
                        color: _filtreType == type ? Colors.white : Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  )).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredHistorique.isEmpty
                    ? const Center(child: Text('Aucune opération trouvée'))
                    : RefreshIndicator(
                        onRefresh: _chargerHistorique,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredHistorique.length,
                          itemBuilder: (context, index) {
                            final item = filteredHistorique[index];
                            final type = item['typeOperation'];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: _couleurType(type).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(_iconeType(type), color: _couleurType(type)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['description'] ?? '',
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['date'].toString().substring(0, 10),
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${item['montant']} F',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: type == 'depot' ? Colors.green : Colors.red,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['statut'] ?? '',
                                          style: const TextStyle(color: Colors.green, fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}