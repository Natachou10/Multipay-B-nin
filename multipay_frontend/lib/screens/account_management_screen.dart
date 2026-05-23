import 'package:flutter/material.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() => _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  // --- ÉTAT DES SEUILS (Dynamique) ---
  double _minBalanceAlert = 5000.0; // Alerte si solde < 5000 FCFA
  double _dailyLimit = 500000.0;   // Plafond journalier
  double _currentDailyUsage = 320000.0; // Montant déjà transféré aujourd'hui

  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    double progress = _currentDailyUsage / _dailyLimit;

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text("Seuils et Limites"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("SURVEILLANCE DU FLUX JOURNALIER"),
            
            // --- CARTE JAUGE DE LIMITE ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Utilisation du plafond", style: TextStyle(color: Colors.white70)),
                      Text("${(progress * 100).toInt()}%", 
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white10,
                    color: progress > 0.9 ? Colors.redAccent : primaryGreen,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${_currentDailyUsage.toInt()} FCFA", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      Text("Limite: ${_dailyLimit.toInt()} FCFA", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("CONFIGURATION DES ALERTES"),

            // --- LISTE DES PARAMÈTRES DE SEUIL ---
            Container(
              decoration: BoxDecoration(
                color: cardDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildThresholdTile(
                    Icons.warning_amber_rounded, 
                    "Alerte solde bas", 
                    "${_minBalanceAlert.toInt()} FCFA",
                    () => _editThreshold("Seuil d'alerte", _minBalanceAlert, (val) => setState(() => _minBalanceAlert = val))
                  ),
                  const Divider(height: 1, indent: 60, color: Colors.white10),
                  _buildThresholdTile(
                    Icons.speed, 
                    "Plafond de vente", 
                    "${_dailyLimit.toInt()} FCFA",
                    () => _editThreshold("Limite journalière", _dailyLimit, (val) => setState(() => _dailyLimit = val)),
                    isLast: true
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            // --- NOTE INFORMATIVE ---
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primaryGreen, size: 20),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      "Ces limites sont locales à l'application pour vous aider à gérer votre stock de monnaie électronique.",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 12),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
    );
  }

  Widget _buildThresholdTile(IconData icon, String title, String value, VoidCallback onTap, {bool isLast = false}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: primaryGreen),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
          const Icon(Icons.edit, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  // Dialogue de modification dynamique
  void _editThreshold(String title, double currentVal, Function(double) onSave) {
    TextEditingController controller = TextEditingController(text: currentVal.toInt().toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            suffixText: "FCFA",
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryGreen)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () {
              onSave(double.parse(controller.text));
              Navigator.pop(context);
            }, 
            child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white))
          ),
        ],
      ),
    );
  }
}