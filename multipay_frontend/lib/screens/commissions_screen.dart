import 'package:flutter/material.dart';

class CommissionsScreen extends StatefulWidget {
  const CommissionsScreen({super.key});

  @override
  State<CommissionsScreen> createState() => _CommissionsScreenState();
}

class _CommissionsScreenState extends State<CommissionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- DONNÉES SIMULÉES ---
  final List<Map<String, dynamic>> _allTransactions = [
    {"op": "MTN", "type": "Dépôt", "amount": "50 000", "gain": 150},
    {"op": "MTN", "type": "Retrait", "amount": "10 000", "gain": 75},
    {"op": "Moov", "type": "Retrait", "amount": "100 000", "gain": 350},
    {"op": "Moov", "type": "Vente Crédit", "amount": "2 000", "gain": 100},
    {"op": "Celtiis", "type": "Dépôt", "amount": "25 000", "gain": 125},
    {"op": "Celtiis", "type": "Retrait", "amount": "5 000", "gain": 40},
  ];

  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {})); // Pour rafraîchir le total
  }

  // --- LOGIQUE DE CALCUL DU TOTAL PAR OPÉRATEUR ---
  double _calculateTotal(String operator) {
    return _allTransactions
        .where((t) => t['op'] == operator)
        .fold(0.0, (sum, item) => sum + item['gain']);
  }

  @override
  Widget build(BuildContext context) {
    String currentOp = _tabController.index == 0 ? "MTN" : (_tabController.index == 1 ? "Moov" : "Celtiis");
    double totalCommission = _calculateTotal(currentOp);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text("Frais et Commissions"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryGreen,
          labelColor: primaryGreen,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "MTN"),
            Tab(text: "MOOV"),
            Tab(text: "CELTIIS"),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- LISTE DES OPÉRATIONS (FICHE) ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOperatorList("MTN"),
                _buildOperatorList("Moov"),
                _buildOperatorList("Celtiis"),
              ],
            ),
          ),

          // --- LIGNE DE COMMISSION TOTALE (FIXÉE EN BAS) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardDark,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Commission actuelle $currentOp", 
                          style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 5),
                      Text("${totalCommission.toInt()} FCFA", 
                          style: TextStyle(color: primaryGreen, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {}, // Vers encaissement ou transfert
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("DÉTAILS", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatorList(String operator) {
    final filteredList = _allTransactions.where((t) => t['op'] == operator).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardDark,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryGreen.withOpacity(0.1),
                    child: Icon(Icons.account_balance_wallet, color: primaryGreen, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['type'], 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text("Montant: ${item['amount']} F", 
                          style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Commission", style: TextStyle(color: Colors.grey, fontSize: 10)),
                  Text("+${item['gain']} FCFA", 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}