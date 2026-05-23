import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // États pour la visibilité du texte
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // Couleurs MultiPay
  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // --- LOGIQUE API ICI ---
      // Envoyer _oldPasswordController.text et _newPasswordController.text au backend Node.js
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF00A859))),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Fermer le loader
        _showSuccessSnackBar();
        Navigator.pop(context); // Retourner aux paramètres
      });
    }
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mot de passe mis à jour avec succès"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = true; // Lié à ton ThemeProvider

    return Scaffold(
      backgroundColor: isDark ? bgDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Sécurité"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Changer le mot de passe",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "Votre nouveau mot de passe doit être différent de l'ancien.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // Champ Ancien Mot de Passe
              _buildPasswordField(
                controller: _oldPasswordController,
                label: "Ancien mot de passe",
                obscure: _obscureOld,
                onToggle: () => setState(() => _obscureOld = !_obscureOld),
                isDark: isDark,
                validator: (val) => val!.isEmpty ? "Veuillez entrer votre ancien mot de passe" : null,
              ),

              const SizedBox(height: 20),

              // Champ Nouveau Mot de Passe
              _buildPasswordField(
                controller: _newPasswordController,
                label: "Nouveau mot de passe",
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                isDark: isDark,
                validator: (val) {
                  if (val!.length < 6) return "Minimum 6 caractères";
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Champ Confirmation
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: "Confirmer le nouveau mot de passe",
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                isDark: isDark,
                validator: (val) {
                  if (val != _newPasswordController.text) return "Les mots de passe ne correspondent pas";
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Bouton Valider
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("METTRE À JOUR", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: isDark ? cardDark : Colors.white,
        prefixIcon: Icon(Icons.lock_outline, color: primaryGreen),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryGreen),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}