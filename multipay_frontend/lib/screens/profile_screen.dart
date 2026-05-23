import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 1. Contrôleurs pour capturer ce que l'utilisateur écrit
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _descController;

  bool _isEditing = false; // Pour savoir si on est en mode modification ou lecture

  @override
  void initState() {
    super.initState();
    // Initialisation avec les données actuelles de l'agent
    _nameController = TextEditingController(text: "Larix Djc");
    _emailController = TextEditingController(text: "djochoularisse@gmail.com");
    _locationController = TextEditingController(text: "Cotonou, Fidjrossè");
    _descController = TextEditingController(text: "Agent certifié MultiPay-Bénin");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // 2. Fonction pour enregistrer
  void _saveProfile() {
    // Ici, tu feras plus tard ton appel API vers ton backend Node.js
    setState(() {
      _isEditing = false; 
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil mis à jour avec succès"),
        backgroundColor: Color(0xFF00A859),
      ),
    );
  }

  // Fonction pour ouvrir le volet de modification
void _showEditSheet(BuildContext context, String title, String currentValue, Function(String) onSave) {
  TextEditingController controller = TextEditingController(text: currentValue);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permet au volet de monter quand le clavier sort
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste selon le clavier
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B), // Ton cardDark
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Modifier $title", 
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.black.withOpacity(0.2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                hintText: "Entrez le nouveau $title",
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$title mis à jour avec succès !"))
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A859), // Ton primaryGreen
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget _buildProfileTile(IconData icon, String label, String value, bool isDark, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: const Color(0xFF00A859)),
    title: Text(label, style: TextStyle(color: isDark ? Colors.grey : Colors.black54, fontSize: 12)),
    subtitle: Text(value, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
    trailing: const Icon(Icons.edit_outlined, size: 18, color: Colors.grey),
    onTap: onTap, // C'est ici que le glissement du bas va se déclencher
  );
}
  @override
  Widget build(BuildContext context) {
    bool isDark = true; // À lier à ton ThemeProvider
    const Color primaryGreen = Color(0xFF00A859);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Bouton pour sortir/annuler si on modifie
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: primaryGreen.withOpacity(0.2),
                child: const Icon(Icons.person, size: 50, color: primaryGreen),
              ),
            ),
            const SizedBox(height: 30),

            // Formulaire
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
  _buildProfileTile(Icons.person_outline, "Nom", _nameController.text, isDark, () {
    _showEditSheet(context, "Nom", _nameController.text, (val) => setState(() => _nameController.text = val));
  }),
  _buildProfileTile(Icons.email_outlined, "Email", _emailController.text, isDark, () {
    _showEditSheet(context, "Email", _emailController.text, (val) => setState(() => _emailController.text = val));
  }),
  _buildProfileTile(Icons.location_on_outlined, "Localisation", _locationController.text, isDark, () {
    _showEditSheet(context, "Localisation", _locationController.text, (val) => setState(() => _locationController.text = val));
  }),
  _buildProfileTile(Icons.description_outlined, "Description", _descController.text, isDark, () {
    _showEditSheet(context, "Description", _descController.text, (val) => setState(() => _descController.text = val));
  }),
],
              ),
            ), //_buildEditField

            const SizedBox(height: 30),

            // Bouton dynamique (Modifier ou Enregistrer)
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? Colors.blueAccent : primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _isEditing ? "ENREGISTRER LES MODIFICATIONS" : "MODIFIER LE PROFIL",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(IconData icon, String label, TextEditingController controller, bool isDark, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            controller: controller,
            enabled: _isEditing, // Le champ s'active uniquement si _isEditing est vrai
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: Icon(icon, color: const Color(0xFF00A859), size: 20),
              border: _isEditing ? const UnderlineInputBorder() : InputBorder.none,
            ),
          ),
        ),
        if (!isLast) const Divider(color: Colors.white10),
      ],
    );
  }
}