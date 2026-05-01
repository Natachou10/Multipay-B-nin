import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'package:flutter/services.dart';


class MerchantConfigScreen extends StatefulWidget {
  const MerchantConfigScreen({super.key});

  @override
  State<MerchantConfigScreen> createState() => _MerchantConfigScreenState();
}

class _MerchantConfigScreenState extends State<MerchantConfigScreen> {
  final Color primaryGreen = const Color(0xFF78B596);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      appBar: AppBar(
        title: const Text("Configuration Marchand", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dernière étape !",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Configurez vos accès opérateurs pour commencer à gérer vos flux.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Section MTN
            _buildOperatorConfig("MTN Bénin", Colors.amber, Icons.star),

            // Section MOOV
            _buildOperatorConfig("Moov Africa", Colors.green, Icons.eco),

            // Section CELTIIS
            _buildOperatorConfig("Celtiis", Colors.blue, Icons.waves),

            const SizedBox(height: 20),

            // Bouton de validation
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Navigation vers le Dashboard après config
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "VALIDER ET ACCÉDER AU TABLEAU DE BORD",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Fonction qui génère les deux champs (Numéro + Code PIN) par opérateur
  Widget _buildOperatorConfig(String label, Color color, IconData icon) {
  return Container(
    margin: const EdgeInsets.only(bottom: 25),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 17)),
          ],
        ),
        const SizedBox(height: 20),
        
        // CHAMP NUMÉRO (Limité à 10 chiffres, doit commencer par 01)
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10), // Bloque à 10 chiffres
          ],
          decoration: InputDecoration(
            labelText: "N° Marchand $label",
            hintText: "Ex: 01xxxxxxxx",
            prefixIcon: const Icon(Icons.phone_android, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
          validator: (value) {
            if (value == null || value.length < 10) return "10 chiffres requis";
            if (!value.startsWith("01")) return "Doit commencer par 01";
            return null;
          },
        ),
        const SizedBox(height: 12),

        // CHAMP CODE PIN (Limité à 5 chiffres)
        TextFormField(
          obscureText: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5), // Bloque à 5 chiffres
          ],
          decoration: InputDecoration(
            labelText: "Code PIN MoMo (5 chiffres)",
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    ),
  );
}
}