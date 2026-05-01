import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multipay_frontend/models/transaction_data.dart';
import 'package:multipay_frontend/screens/settings_screen.dart';
import 'service_form_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _searchQuery = "";
  bool _isBalanceVisible = false;
  final Color pureGreen = const Color(0xFF00A859);
   final List<TransactionData> _historiqueData = [
    TransactionData(
      id: "REF8829301",
      operator: "MTN",
      service: "Dépôts",
      number: "67000000",
      name: "Moustapha ABDOULAYE",
      amount: "5000",
      dateTime: DateTime.now(),
      isSuccess: true,
    ),
    TransactionData(
      id: "REF8829302",
      operator: "MOOV",
      service: "Retraits",
      number: "95123456",
      amount: "2500",
      dateTime: DateTime.now().subtract(const Duration(minutes: 15)),
      isSuccess: true,
    ),
    TransactionData(
      id: "REF8829303",
      operator: "CELTIIS",
      service: "Crédit",
      number: "40001122",
      amount: "1000",
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      isSuccess: true,
    ),
  ];

  // --- DONNÉES DE TEST (Opérateur - Opération - Cible - Montant - Statut) ---
  // NOUVEAU CODE
final List<TransactionData> transactions = [
  TransactionData(
    id: "772109231",
    operator: "MTN",
    service: "Dépôts",
    number: "67000000",
    name: "Moustapha ABDOULAYE",
    amount: "5000",
    dateTime: DateTime.now(),
    isSuccess: true,
  ),
  TransactionData(
    id: "772109235",
    operator: "MOOV",
    service: "Retraits",
    number: "95123456",
    amount: "2500",
    dateTime: DateTime.now().subtract(const Duration(hours: 1)),
    isSuccess: true,
  ),
  TransactionData(
    id: "772109240",
    operator: "CELTIIS",
    service: "Crédit",
    number: "40112233",
    amount: "1000",
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    isSuccess: false,
  ),
];

  void showStatusNotification(String message, String status) {
    Color bgColor = status == 'success' ? Colors.green : (status == 'error' ? Colors.red : Colors.orange);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 100, left: 20, right: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHome(),             // Index 0
                _buildTransactionsPage(),  // Index 1 (Dépôts / Retraits)
                _buildHistoryPage(),       // Index 2 (Tout)
                _buildSettingsPage(),      // Index 3
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: pureGreen,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Transactions"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historique"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Paramètres"),
        ],
      ),
    );
  }

  // --- HEADER CLIQUABLE ---
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
      decoration: BoxDecoration(
        color: pureGreen,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = 3),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, backgroundColor: Colors.white24, child: Icon(Icons.person, color: Colors.white, size: 35)),
            const SizedBox(width: 15),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Larisse Djochou", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                Text("ID Agent: BJ-9920", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- PAGE ACCUEIL ---
  Widget _buildHome() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBalanceSection(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text("SERVICES PRINCIPAUX", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5A717E), fontSize: 17)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _mainServiceCard(Icons.credit_card, "Crédits", Colors.orange)),
                    const SizedBox(width: 25),
                    Expanded(child: _mainServiceCard(Icons.inventory_2_outlined, "Forfaits", Colors.green)),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _mainServiceCard(Icons.arrow_downward, "Dépôts", const Color.fromARGB(255, 146, 238, 161))),
                    const SizedBox(width: 25),
                    Expanded(child: _mainServiceCard(Icons.arrow_upward, "Retraits", Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AUTRES SERVICES", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5A717E), fontSize: 17)),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _otherServiceCircle(Icons.school, "Scolarité", Colors.blue,),
                    _otherServiceCircle(Icons.tv, "Canal+", Colors.red),
                    _otherServiceCircle(Icons.water_drop, "SONEB", Colors.cyan),
                    _otherServiceCircle(Icons.electric_bolt, "SBEE", Colors.orange),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SECTION SOLDES ---
  Widget _buildBalanceSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _balanceItem("MTN", "545.000", Colors.amber),
              _balanceItem("MOOV", "210.500", Colors.green),
              _balanceItem("CELTIIS", "85.000", Colors.blue),
            ],
          ),
          const Divider(height: 35),
          InkWell(
            onTap: () => setState(() => _isBalanceVisible = !_isBalanceVisible),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isBalanceVisible ? Icons.visibility_off : Icons.visibility, color: const Color.fromARGB(255, 73, 73, 73), size: 25),
                const SizedBox(width: 15),
                Text(_isBalanceVisible ? "Masquer les soldes" : "Afficher les soldes", style: const TextStyle(color: Color.fromARGB(255, 27, 27, 27), fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceItem(String label, String amount, Color color) {
    return Column(
      children: [
        CircleAvatar(radius: 18, backgroundColor: color.withOpacity(0.1), child: Text(label[0], style: TextStyle(color: color, fontWeight: FontWeight.bold))),
        const SizedBox(height: 15),
        Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        Text(_isBalanceVisible ? "$amount F" : "••••••", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
// --- PAGES TRANSACTIONS & HISTORIQUE (UNIFORMISÉES) ---
  Widget _buildTransactionsPage() {
    // Filtrage des flux de caisse (Dépôts et Retraits uniquement)
    final fluxList = _historiqueData.where((tx) => 
      tx.service == 'Dépôts' || tx.service == 'Retraits'
    ).toList();
    
    return _buildListViewPage("Flux de Caisse", fluxList);
  }

  Widget _buildHistoryPage() {
    return _buildListViewPage("Toutes les opérations", _historiqueData);
  }

  Widget _buildListViewPage(String title, List<TransactionData> data) {
  // LOGIQUE DE FILTRE : On filtre la liste 'data' selon la saisie
  final filteredData = data.where((tx) {
    final query = _searchQuery.toLowerCase();
    return tx.number.contains(query) || 
           tx.id.toLowerCase().contains(query) || 
           tx.service.toLowerCase().contains(query);
  }).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // TITRE ET BARRE DE RECHERCHE
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            // CHAMP DE RECHERCHE
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Met à jour et redessine la liste
                });
              },
              decoration: InputDecoration(
                hintText: "Rechercher un numéro ou une réf...",
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ],
        ),
      ),

      // AFFICHAGE DES RÉSULTATS
      Expanded(
        child: filteredData.isEmpty 
          ? _buildEmptySearch() // Si aucun résultat
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: filteredData.length,
              itemBuilder: (context, index) => _buildTransactionItem(filteredData[index]),
            ),
      ),
    ],
  );
}

// Widget pour quand la recherche ne trouve rien
Widget _buildEmptySearch() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 60, color: Colors.grey.shade300),
        const SizedBox(height: 10),
        const Text("Aucune transaction trouvée", style: TextStyle(color: Colors.grey)),
      ],
    ),
  );
}

  // WIDGET D'ITEM UNIFORMISÉ (Opérateur - Opération - Cible - Montant - Statut)
  Widget _buildTransactionItem(TransactionData tx) {
  // Définition de la couleur selon l'opérateur
  Color opColor;
  if (tx.operator == 'MTN') {
    opColor = Colors.amber;
  } else if (tx.operator == 'MOOV') {
    opColor = Colors.green;
  } else {
    opColor = Colors.blue;
  }

  bool isDepot = tx.service == "Dépôts";

  return Card(
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), 
      side: BorderSide(color: Colors.grey.withOpacity(0.1))
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: opColor.withOpacity(0.1), 
              child: Text(
                tx.operator[0], 
                style: TextStyle(color: opColor, fontWeight: FontWeight.bold)
              )
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${tx.operator} - ${tx.service}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blueGrey)
                ),
                // Affichage de la date et l'heure
                Text(
                  "${tx.dateTime.day}/${tx.dateTime.month} ${tx.dateTime.hour}:${tx.dateTime.minute.toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logique : Nom + Numéro si Dépôt, sinon Numéro seul
                  if (isDepot && tx.name != null) ...[
                    Text(tx.name!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                    Text(tx.number, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                  ] else ...[
                    Text(tx.number, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                  ],
                ],
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${tx.amount} F", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                // Badge de statut
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: tx.isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    tx.isSuccess ? 'Réussi' : 'Échec', 
                    style: TextStyle(
                      color: tx.isSuccess ? Colors.green : Colors.red, 
                      fontSize: 9, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ],
            ),
          ),
          // Ligne discrète pour le Code de Référence (ID)
          Padding(
            padding: const EdgeInsets.only(left: 72, right: 16, bottom: 8),
            child: Row(
              children: [
                Icon(Icons.fingerprint, size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  "RÉF: ${tx.id}",
                  style: TextStyle(
                    fontSize: 10, 
                    color: Colors.grey.shade500, 
                    fontFamily: 'monospace',
                    letterSpacing: 0.5
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  // --- PAGE PARAMÈTRES ---
  Widget _buildSettingsPage() {
    return const SettingsScreen();
  }

  Widget settingsTile(IconData icon, String title, String sub, Color col) {
    return ListTile(
      leading: Icon(icon, color: col),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    );
  }

  // --- WIDGETS SERVICES ---
  Widget _mainServiceCard(IconData icon, String label, Color color) {
    return Container(
      height: 90,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: InkWell(
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ServiceFormScreen(
        serviceName: label, // Ex: "Dépôts"
        themeColor: color,  // Ex: Colors.orange
      ),
    ),
  );
},        borderRadius: BorderRadius.circular(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
      ),
    );
  }

  Widget _otherServiceCircle(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceFormScreen(serviceName: label, themeColor: color))),
      child: Column(children: [
        Container(height: 45, width: 45, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  
// Le design du reçu qui sera transformé en image

}
