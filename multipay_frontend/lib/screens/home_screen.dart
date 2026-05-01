import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        title: const ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text("mamou", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text("Multi-Pay Bénin", style: TextStyle(color: Colors.white70)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section des Cartes Réseaux
            Row(
              children: [
                _buildNetworkCard("MTN", "******", Colors.yellow[700]!),
                const SizedBox(width: 10),
                _buildNetworkCard("MOOV", "******", Colors.green[100]!),
                const SizedBox(width: 10),
                _buildNetworkCard("CELTIIS", "******", Colors.blue[100]!),
              ],
            ),
            const SizedBox(height: 25),
            const Text("SERVICES", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 15),
            // Grille des services
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _buildServiceItem(Icons.credit_card, "Crédits", Colors.orange),
                _buildServiceItem(Icons.inventory_2, "Forfaits", Colors.green),
                _buildServiceItem(Icons.arrow_circle_down, "Dépôts", Colors.amber),
                _buildServiceItem(Icons.arrow_circle_up, "Retraits", Colors.red),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transaction"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Trésorerie"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionModal(context),
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildNetworkCard(String name, String balance, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(balance, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.visibility_off_outlined, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

void _showTransactionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Nouvelle opération", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20),
          // Boutons Dépôt/Retrait/etc.
          Wrap(
            spacing: 10,
            children: [
              ChoiceChip(label: const Text("Dépôt"), selected: true, selectedColor: Colors.green[700], labelStyle: const TextStyle(color: Colors.white)),
              const ChoiceChip(label: Text("Retrait"), selected: false),
              const ChoiceChip(label: Text("Crédit"), selected: false),
            ],
          ),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: "N° Client", hintText: "Ex: 97XXXXXX")),
          const SizedBox(height: 15),
          const TextField(decoration: InputDecoration(labelText: "Montant (FCFA)", suffixText: "FCFA")),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[300], minimumSize: const Size(double.infinity, 50)),
            child: const Text("VALIDER"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

}

