import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // État local pour les toggles (À connecter plus tard à SharedPreferences ou Firebase)
  bool _pushNotifications = true;
  bool _biometricEnabled = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Fond moderne bleuté très clair
      
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          // --- SECTION : MON COMPTE ---
          _buildSectionHeader("MON COMPTE"),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.person_rounded,
              iconColor: Colors.blue,
              title: "Profil de l'Agent",
              subtitle: "Moustapha ABDOULAYE",
              onTap: () {},
            ),
            _buildSettingsDivider(),
            _buildSettingsTile(
              icon: Icons.store_rounded,
              iconColor: Colors.orange,
              title: "Ma Boutique / Agence",
              subtitle: "Agence Cotonou-Centre",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 32),

          // --- SECTION : PRÉFÉRENCES (Notifications ajoutées ici) ---
          _buildSectionHeader("PRÉFÉRENCES"),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.notifications_active_rounded,
              iconColor: Colors.purple,
              title: "Notifications Push",
              subtitle: "Alertes transactions & commissions",
              value: _pushNotifications,
              onChanged: (val) => setState(() => _pushNotifications = val),
            ),
            _buildSettingsDivider(),
            _buildSwitchTile(
              icon: Icons.dark_mode_rounded,
              iconColor: Colors.indigo,
              title: "Mode Sombre",
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
            ),
          ]),

          const SizedBox(height: 32),

          // --- SECTION : SÉCURITÉ ---
          _buildSectionHeader("SÉCURITÉ"),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.lock_rounded,
              iconColor: Colors.teal,
              title: "Changer mon code PIN",
              onTap: () {},
            ),
            _buildSettingsDivider(),
            _buildSwitchTile(
              icon: Icons.fingerprint_rounded,
              iconColor: Colors.blueGrey,
              title: "Empreinte Digitale",
              value: _biometricEnabled,
              onChanged: (val) => setState(() => _biometricEnabled = val),
            ),
          ]),

          const SizedBox(height: 32),

          // --- SECTION : SUPPORT ---
          _buildSectionHeader("SUPPORT"),
          _buildSettingsCard([
            _buildSettingsTile(
              icon: Icons.help_center_rounded,
              iconColor: Colors.green,
              title: "Aide & Centre de Support",
              onTap: () {},
            ),
            _buildSettingsDivider(),
            _buildSettingsTile(
              icon: Icons.info_rounded,
              iconColor: Colors.grey,
              title: "À propos de Multipay",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 48),

          // --- BOUTON DÉCONNEXION (En bas de page) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextButton(
              onPressed: () => _showLogoutDialog(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.08),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red),
                  SizedBox(width: 12),
                  Text(
                    "SE DÉCONNECTER",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Multipay Benin - v1.0.2",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- WIDGETS DE CONSTRUCTION ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13)) : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 13)) : null,
      trailing: Switch.adaptive(
        value: value,
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSettingsDivider() {
    return Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey.shade100);
  }

  // Dialogue de confirmation de déconnexion
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Déconnexion"),
        content: const Text("Êtes-vous sûr de vouloir fermer votre session ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULER", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              // Logique de déconnexion ici
              Navigator.pop(context);
            },
            child: const Text("OUI, SORTIR", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
