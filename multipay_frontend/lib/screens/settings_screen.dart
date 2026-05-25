import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:multipay_frontend/main.dart';
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
  String _nomAgent = 'Chargement...';
  String _email = '';
  String _localisation = '';
  String _description = '';

  final Color primaryGreen = const Color(0xFF00A859);
  final Color cardDark = const Color(0xFF1E293B);
  final Color bgDark = const Color(0xFF0F172A);

 @override
void initState() {
  super.initState();
  _chargerProfil();
  // Synchroniser avec le thème global
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    setState(() => _isDarkMode = themeProvider.isDarkMode);
  });
}

 void _showSeuilsDialog() async {
  final seuilVertController = TextEditingController(text: '10000');
  final seuilOrangeController = TextEditingController(text: '5000');

  // Charger les seuils existants
  final data = await ApiService.consulterSeuils();
  final seuils = data['seuils'] ?? [];
  for (var s in seuils) {
    if (s['cle'] == 'seuil_vert') seuilVertController.text = s['valeur'];
    if (s['cle'] == 'seuil_orange') seuilOrangeController.text = s['valeur'];
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: _isDarkMode ? cardDark : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Seuils et Limites", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Indicateur visuel
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSeuilIndicateur("Suffisant", Colors.green),
              _buildSeuilIndicateur("Bas", Colors.orange),
              _buildSeuilIndicateur("Critique", Colors.red),
            ],
          ),
          const SizedBox(height: 20),

          // Seuil vert
          TextField(
            controller: seuilVertController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Seuil suffisant (FCFA)",
              prefixIcon: const Icon(Icons.circle, color: Colors.green, size: 16),
              border: const OutlineInputBorder(),
              helperText: "Au-dessus de ce montant → vert",
            ),
          ),
          const SizedBox(height: 15),

          // Seuil orange
          TextField(
            controller: seuilOrangeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Seuil bas (FCFA)",
              prefixIcon: const Icon(Icons.circle, color: Colors.orange, size: 16),
              border: const OutlineInputBorder(),
              helperText: "Entre ce montant et le seuil vert → orange",
            ),
          ),
          const SizedBox(height: 5),
          const Text("En dessous du seuil bas → rouge", 
            style: TextStyle(color: Colors.red, fontSize: 12)),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () async {
                Navigator.pop(context);
                await ApiService.modifierSeuil({
                  'cle': 'seuil_vert',
                  'valeur': seuilVertController.text,
                  'description': 'Seuil solde suffisant'
                });
                await ApiService.modifierSeuil({
                  'cle': 'seuil_orange',
                  'valeur': seuilOrangeController.text,
                  'description': 'Seuil solde bas'
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seuils mis à jour'), backgroundColor: Colors.green)
                );
              },
              child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Widget _buildSeuilIndicateur(String label, Color color) {
  return Column(
    children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
        child: Icon(Icons.account_balance_wallet, color: color, size: 20),
      ),
      const SizedBox(height: 5),
      Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    ],
  );
}
  
void _showFraisDialog() async {
  final data = await ApiService.consulterFrais();
  final frais = data['frais'] ?? [];

  showModalBottomSheet(
    context: context,
    backgroundColor: _isDarkMode ? cardDark : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Frais et Commissions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          frais.isEmpty
            ? const Text("Aucun tarif configuré", style: TextStyle(color: Colors.grey))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: frais.length,
                itemBuilder: (context, index) {
                  final f = frais[index];
                  return ListTile(
                    title: Text('${f['typeOperation']} - ${f['operateur'] ?? 'Tous'}'),
                    trailing: Text('${f['pourcentage']}%', 
                      style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                  );
                },
              ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

  Future<void> _chargerProfil() async {
    final data = await ApiService.consulterProfil();
    if (data['revendeur'] != null) {
      setState(() {
        _nomAgent = data['revendeur']['nom'] ?? '';
        _email = data['revendeur']['email'] ?? '';
      });
    }
  }

  Future<void> _sauvegarderProfil() async {
    final result = await ApiService.modifierProfil({
      'nom': _nomAgent,
      'localisation': _localisation,
      'description': _description,
    });
    if (result['message'] == 'Profil mis à jour') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour'), backgroundColor: Colors.green)
      );
    }
  }

  void _modifierChamp(String titre, String valeurActuelle, Function(String) onSave) {
    final controller = TextEditingController(text: valeurActuelle);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? cardDark : Colors.white,
        title: Text("Modifier $titre"),
        content: TextField(
          controller: controller,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: "Nouveau : $titre",
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULER"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () async {
              Navigator.pop(context);
              onSave(controller.text.trim());
            },
            child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _changerMotDePasse() {
    final ancienController = TextEditingController();
    final nouveauController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? cardDark : Colors.white,
        title: const Text("Changer mot de passe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ancienController,
              obscureText: true,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
              decoration: const InputDecoration(
                labelText: "Ancien mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: nouveauController,
              obscureText: true,
              style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
              decoration: const InputDecoration(
                labelText: "Nouveau mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ANNULER"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
            onPressed: () async {
              Navigator.pop(context);
              final result = await ApiService.changerMotDePasse({
                'ancienMotDePasse': ancienController.text,
                'nouveauMotDePasse': nouveauController.text,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result['message'] ?? 'Erreur'),
                  backgroundColor: result['message'] == 'Mot de passe modifié avec succès'
                      ? Colors.green
                      : Colors.red,
                ),
              );
            },
            child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = _isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Paramètres", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
              _buildListTile(Icons.person_outline, "Nom de l'agent", _nomAgent, isDark,
                onTap: () => _modifierChamp("nom", _nomAgent, (val) async {
                  setState(() => _nomAgent = val);
                  await _sauvegarderProfil();
                })
              ),
              _buildListTile(Icons.email_outlined, "Email", _email, isDark),
              _buildListTile(Icons.location_on_outlined, "Localisation",
                _localisation.isEmpty ? 'Non définie' : _localisation, isDark,
                onTap: () => _modifierChamp("localisation", _localisation, (val) async {
                  setState(() => _localisation = val);
                  await _sauvegarderProfil();
                })
              ),
              _buildListTile(Icons.description_outlined, "Description",
                _description.isEmpty ? 'Non définie' : _description, isDark,
                isLast: true,
                onTap: () => _modifierChamp("description", _description, (val) async {
                  setState(() => _description = val);
                  await _sauvegarderProfil();
                })
              ),
            ]),

            // --- SECTION PRÉFÉRENCES ---
            _buildSectionTitle("Préférences", isDark),
            _buildSettingsCard(isDark, [
              _buildSwitchTile(Icons.dark_mode_outlined, "Mode Sombre", _isDarkMode, (val) {
  Provider.of<ThemeProvider>(context, listen: false).toggleTheme(val);
  setState(() => _isDarkMode = val);
}, isDark),
              _buildListTile(Icons.language_outlined, "Langue", _selectedLanguage, isDark,
                onTap: () => _showLanguagePicker()),
              _buildSwitchTile(Icons.notifications_none_outlined, "Notifications", _notificationsEnabled, (val) {
                setState(() => _notificationsEnabled = val);
              }, isDark, isLast: true),
            ]),

            // --- SECTION SÉCURITÉ ---
            _buildSectionTitle("Sécurité", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.lock_reset_outlined, "Changer mot de passe", null, isDark,
                onTap: () => _changerMotDePasse()),
              _buildListTile(Icons.timer_outlined, "Délai d'activité", _sessionTimeout, isDark,
                isLast: true, onTap: () => _showTimeoutPicker()),
            ]),

            // // --- SECTION GESTION ---
_buildSectionTitle("Gestion de comptes", isDark),
_buildSettingsCard(isDark, [
  _buildListTile(Icons.trending_up_outlined, "Seuils et Limites", null, isDark,
    onTap: () => _showSeuilsDialog()),
  _buildListTile(Icons.account_balance_wallet_outlined, "Frais et Commissions", null, isDark,
    isLast: true, onTap: () => _showFraisDialog()),
]),

            // --- SECTION SUPPORT ---
            _buildSectionTitle("Support & Informations", isDark),
            _buildSettingsCard(isDark, [
              _buildListTile(Icons.assignment_outlined, "Conditions d'utilisation", null, isDark, 
  onTap: () => _showConditions()),
_buildListTile(Icons.privacy_tip_outlined, "Politique de confidentialité", null, isDark, 
  onTap: () => _showPolitique()),
              _buildListTile(Icons.info_outline, "À propos", "v1.0.2", isDark, 
                isLast: true, 
                onTap: () => _showAPropos()),
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
        borderRadius: BorderRadius.circular(15),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile(IconData icon, String title, String? trailing, bool isDark,
      {bool isLast = false, VoidCallback? onTap}) {
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

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged,
      bool isDark, {bool isLast = false}) {
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

void _showConditions() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: _isDarkMode ? cardDark : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Conditions d'utilisation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  """1. ACCEPTATION DES CONDITIONS
En utilisant MultiPay-Bénin, vous acceptez les présentes conditions d'utilisation.

2. DESCRIPTION DU SERVICE
MultiPay-Bénin est une application de gestion intégrée des services GSM au Bénin permettant aux revendeurs agréés d'effectuer des opérations de Mobile Money.

3. RESPONSABILITÉS DE L'UTILISATEUR
- L'utilisateur est responsable de la confidentialité de son code PIN et mot de passe.
- Toute transaction effectuée avec vos identifiants est de votre responsabilité.
- Vous devez signaler immédiatement toute utilisation non autorisée de votre compte.

4. TRANSACTIONS
- Toutes les transactions sont définitives et ne peuvent être annulées qu'en contactant le support.
- Des frais de service s'appliquent selon les tarifs en vigueur.

5. LIMITATION DE RESPONSABILITÉ
MultiPay-Bénin ne peut être tenu responsable des pertes résultant d'une utilisation frauduleuse de votre compte.

6. MODIFICATION DES CONDITIONS
Nous nous réservons le droit de modifier ces conditions à tout moment avec notification préalable.

7. CONTACT
Pour toute question : support@multipay.bj""",
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                onPressed: () => Navigator.pop(context),
                child: const Text("J'AI COMPRIS", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showPolitique() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: _isDarkMode ? cardDark : Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Politique de confidentialité", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  """1. COLLECTE DES DONNÉES
MultiPay-Bénin collecte les informations suivantes :
- Nom et coordonnées du revendeur
- Historique des transactions
- Données de connexion

2. UTILISATION DES DONNÉES
Vos données sont utilisées pour :
- Gérer votre compte et vos transactions
- Améliorer nos services
- Assurer la sécurité de la plateforme

3. PROTECTION DES DONNÉES
Nous mettons en œuvre des mesures de sécurité strictes :
- Chiffrement des mots de passe
- Authentification par token JWT
- Connexions sécurisées

4. PARTAGE DES DONNÉES
Vos données ne sont jamais vendues à des tiers. Elles peuvent être partagées uniquement avec les opérateurs télécom (MTN, MOOV, CELTIIS) pour le traitement des transactions.

5. CONSERVATION DES DONNÉES
Vos données sont conservées pendant toute la durée de votre utilisation du service et 2 ans après la clôture de votre compte.

6. VOS DROITS
Vous disposez d'un droit d'accès, de rectification et de suppression de vos données personnelles.

7. CONTACT
Pour exercer vos droits : privacy@multipay.bj""",
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                onPressed: () => Navigator.pop(context),
                child: const Text("FERMER", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showAPropos() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: _isDarkMode ? cardDark : Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70, width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [Color(0xFF2D764F), Color(0xFFD34C4C)]
              ),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 15),
          const Text("MultiPay-Bénin", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Version 1.0.2", style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.grey)),
          const SizedBox(height: 15),
          Text(
            "Application de gestion intégrée des services GSM au Bénin.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87),
          ),
          const SizedBox(height: 10),
          Text("© 2026 MultiPay-Bénin", style: TextStyle(color: _isDarkMode ? Colors.white38 : Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Text("Développé par Larix Djc", style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
          onPressed: () => Navigator.pop(context),
          child: const Text("FERMER", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? cardDark : Colors.white,
        title: const Text("Déconnexion"),
        content: const Text("Voulez-vous vraiment vous déconnecter de MultiPay ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("ANNULER")),
          TextButton(
            onPressed: () async {
              await ApiService.supprimerToken();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text("OUI", style: TextStyle(color: Colors.red))
          ),
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
              _buildLanguageOption("Français"),
              _buildLanguageOption("English"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String lang) {
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
            onChanged: (val) async {
              setState(() => _sessionTimeout = val!);
              Navigator.pop(context);
              await ApiService.modifierDelaiActivite({'delai': int.parse(val!.split(' ')[0])});
            },
          )).toList(),
        ),
      ),
    );
  }
}