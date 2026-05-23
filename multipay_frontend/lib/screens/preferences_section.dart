import 'package:flutter/material.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  // --- ÉTAT DYNAMIQUE ---
  bool _isDarkMode = true; // État du thème
  bool _notificationsEnabled = true; // État des notifications
  String _selectedLanguage = "Français"; // Langue sélectionnée

  // Couleurs de la charte MultiPay
  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    // La couleur de fond réagit dynamiquement au switch
    final Color currentBg = _isDarkMode ? bgDark : const Color(0xFFF1F5F9);
    final Color currentCard = _isDarkMode ? cardDark : Colors.white;
    final Color textColor = _isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: currentBg,
      appBar: AppBar(
        title: const Text("Préférences"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel("STYLE ET APPARENCE"),
            
            // --- CARTE DYNAMIQUE ---
            Container(
              decoration: BoxDecoration(
                color: currentCard,
                borderRadius: BorderRadius.circular(15),
                boxShadow: _isDarkMode ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  // SWITCH THÈME
                  _buildSwitchTile(
                    icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    title: "Mode Sombre",
                    subtitle: _isDarkMode ? "Activé" : "Désactivé",
                    value: _isDarkMode,
                    onChanged: (val) {
                      setState(() => _isDarkMode = val);
                      // Ici tu pourras appeler ton ThemeProvider global plus tard
                    },
                    textColor: textColor,
                  ),
                  
                  const Divider(height: 1, indent: 60),

                  // SÉLECTEUR DE LANGUE
                  _buildActionTile(
                    icon: Icons.translate,
                    title: "Langue de l'application",
                    trailingText: _selectedLanguage,
                    onTap: () => _showLanguageSelector(),
                    textColor: textColor,
                  ),

                  const Divider(height: 1, indent: 60),

                  // SWITCH NOTIFICATIONS
                  _buildSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: "Notifications Push",
                    subtitle: "Alertes de transactions et sécurité",
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                    },
                    textColor: textColor,
                    isLast: true,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            Text(
              "Les modifications sont appliquées instantanément à votre profil agent.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS INTERNES ---

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color textColor,
    bool isLast = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryGreen),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: primaryGreen,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String trailingText,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: primaryGreen),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailingText, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // --- LOGIQUE DYNAMIQUE DU SÉLECTEUR DE LANGUE ---
  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? cardDark : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choisir la langue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildLanguageOption("Français", "FR"),
              _buildLanguageOption("English", "EN"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String lang, String code) {
    bool isSelected = _selectedLanguage == lang;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSelected ? primaryGreen : Colors.grey.withOpacity(0.1),
        child: Text(code, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
      ),
      title: Text(lang, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
      trailing: isSelected ? Icon(Icons.check_circle, color: primaryGreen) : null,
      onTap: () {
        setState(() => _selectedLanguage = lang);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Langue changée en $lang"), duration: const Duration(seconds: 1)),
        );
      },
    );
  }
}