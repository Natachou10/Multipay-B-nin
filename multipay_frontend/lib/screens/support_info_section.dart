import 'package:flutter/material.dart';

class SupportInfoSection extends StatelessWidget {
  const SupportInfoSection({super.key});

  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text("Support & Informations"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- CARTE DES INFORMATIONS ---
                  Container(
                    decoration: BoxDecoration(
                      color: cardDark,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(context, Icons.description_outlined, "Conditions d'utilisation", "Lire les règles d'usage"),
                        const Divider(height: 1, indent: 60, color: Colors.white10),
                        _buildInfoTile(context, Icons.privacy_tip_outlined, "Politique de confidentialité", "Protection de vos données"),
                        const Divider(height: 1, indent: 60, color: Colors.white10),
                        _buildInfoTile(context, Icons.info_outline, "À propos de MultiPay", "Version 1.0.2 - Licence L3"),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Petit texte de copyright pour le mémoire
                  const Text(
                    "© 2026 MultiPay-Bénin. Tous droits réservés.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),

          // --- BOUTON DÉCONNEXION (BAS ET CENTRÉ) ---
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: TextButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                "Déconnexion",
                style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: primaryGreen),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {
        // Logique pour afficher le contenu textuel
        _showTextContent(context, title);
      },
    );
  }

  void _showTextContent(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text(
              "Ceci est un texte de démonstration pour le projet de mémoire MultiPay-Bénin. "
              "Il détaille les clauses juridiques, les responsabilités de l'agent mobile money "
              "et la gestion de la sécurité des transactions.",
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: const Text("J'AI COMPRIS", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        title: const Text("Déconnexion", style: TextStyle(color: Colors.white)),
        content: const Text("Voulez-vous vraiment quitter MultiPay ?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          TextButton(
            onPressed: () {
              // Logique de nettoyage de session ici
              Navigator.pop(context);
            }, 
            child: const Text("DÉCONNEXION", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }
}