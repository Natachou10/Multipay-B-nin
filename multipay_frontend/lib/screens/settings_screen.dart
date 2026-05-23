import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'preferences_section.dart';
import 'change_password_screen.dart';
import 'operator_pin_screen.dart';
import 'account_management_screen.dart';
import 'commissions_screen.dart';
import 'support_info_section.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = "Français";
  String _sessionTimeout = "15 min";

  // Couleurs personnalisées pour un look Premium
  final Color primaryGreen = const Color(0xFF00A859);
  final Color cardDark = const Color(0xFF1E293B);
  final Color bgDark = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    bool isDark = _isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
  title: const Text("Paramètres", style: TextStyle(fontWeight: FontWeight.bold)),
  elevation: 0,
  automaticallyImplyLeading: false, 
  backgroundColor: isDark ? bgDark : Colors.white,
  foregroundColor: isDark ? Colors.white : Colors.black,
),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // --- SECTION MON PROFIL ---
            _buildSectionTitle("Mon Profil", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.person_outline, "Nom de l'agent", "Larix Djc", isDark),
              _buildListTile(Icons.email_outlined, "Email", "djochoularisse@gmail.com", isDark),
              _buildListTile(Icons.location_on_outlined, "Localisation", "Cotonou, Bénin", isDark),
              _buildListTile(Icons.description_outlined, "Description", "Agent MultiPay Principal", isDark, isLast: true),
            ]),

            // --- SECTION PRÉFÉRENCES ---
            _buildSectionTitle("Préférences", isDark),
            _buildSettingsCard(isDark, [
              _buildSwitchTile(Icons.dark_mode_outlined, "Mode Sombre", _isDarkMode, (val) {
                setState(() => _isDarkMode = val);
              }, isDark),
              _buildListTile(Icons.language_outlined, "Langue", _selectedLanguage, isDark, onTap: () => _showLanguagePicker()),
              _buildSwitchTile(Icons.notifications_none_outlined, "Notifications", _notificationsEnabled, (val) {
                setState(() => _notificationsEnabled = val);
              }, isDark, isLast: true),
            ]),

            // --- SECTION SÉCURITÉ ---
            _buildSectionTitle("Sécurité", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.lock_reset_outlined, "Changer mot de passe", null, isDark, onTap: () {}),
              _buildListTile(Icons.dialpad_outlined, "Changer code PIN (Par opérateur)", null, isDark, onTap: () {}),
              _buildListTile(Icons.timer_outlined, "Délai d'activité", _sessionTimeout, isDark, isLast: true, onTap: () => _showTimeoutPicker()),
            ]),

            // --- SECTION GESTION ---
            _buildSectionTitle("Gestion de comptes", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.trending_up_outlined, "Seuils et Limites", null, isDark, onTap: () {}),
              _buildListTile(Icons.account_balance_wallet_outlined, "Frais et Commissions", null, isDark, isLast: true, onTap: () {}),
            ]),

            // --- SECTION SUPPORT ---
            _buildSectionTitle("Support & Informations", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.assignment_outlined, "Conditions d'utilisation", null, isDark, onTap: () {}),
              _buildListTile(Icons.privacy_tip_outlined, "Politique de confidentialité", null, isDark, onTap: () {}),
              _buildListTile(Icons.info_outline, "À propos", "v1.0.2", isDark, isLast: true),
            ]),

            const SizedBox(height: 30),

            // --- BOUTON DÉCONNEXION ---
            Center(
              child: TextButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text("Déconnexion", 
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title.toUpperCase(),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark ? Colors.white54 : Colors.grey.shade600)),
      ),
    );
  }

  Widget _buildSettingsCard(bool isDark, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? cardDark : Colors.white,
        borderRadius: BorderRadius.circular(15), // Angles arrondis pro (15px)
border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(IconData icon, String title, String? trailing, bool isDark, {bool isLast = false, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: isDark ? primaryGreen : Colors.indigo.shade400, size: 22),
          title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailing != null)
                Text(trailing, style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 14)),
              const SizedBox(width: 5),
              Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white24 : Colors.grey.shade400),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, indent: 55, color: isDark ? Colors.white10 : Colors.grey.shade100),
      ],
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged, bool isDark, {bool isLast = false}) {
    return Column(
      children: [
        SwitchListTile(
          secondary: Icon(icon, color: isDark ? primaryGreen : Colors.indigo.shade400, size: 22),
          title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 15)),
          value: value,
          activeColor: primaryGreen,
          onChanged: onChanged,
        ),
        if (!isLast) Divider(height: 1, indent: 55, color: isDark ? Colors.white10 : Colors.grey.shade100),
      ],
    );
  }

  // --- DIALOGUES ---

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? cardDark : Colors.white,
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter de MultiPay ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          TextButton(onPressed: () {}, child: const Text("OUI", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

 void _showLanguagePicker() {
  showModalBottomSheet(
    context: context,
    backgroundColor: _isDarkMode ? cardDark : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choisir la langue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildLanguageOption("Français", "flag_france"), // Tu pourras mettre des icônes plus tard
            _buildLanguageOption("English", "flag_usa"),
          ],
        ),
      );
    },
  );
}

Widget _buildLanguageOption(String lang, String flag) {
  return ListTile(
    title: Text(lang, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
    trailing: _selectedLanguage == lang ? Icon(Icons.check_circle, color: primaryGreen) : null,
    onTap: () {
      setState(() => _selectedLanguage = lang);
      Navigator.pop(context);
    },
  );
}

 void _showTimeoutPicker() {
  final List<String> options = ["15 min", "20 min", "Jamais"];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _isDarkMode ? cardDark : Colors.white,
      title: const Text("Délai d'activité"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((opt) => RadioListTile<String>(
          title: Text(opt, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
          value: opt,
          groupValue: _sessionTimeout,
          activeColor: primaryGreen,
          onChanged: (val) {
            setState(() => _sessionTimeout = val!);
            Navigator.pop(context);
          },
        )).toList(),
      ),
    ),
  );
}
}