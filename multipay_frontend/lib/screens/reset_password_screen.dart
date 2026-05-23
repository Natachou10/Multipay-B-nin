import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email; // On garde l'email pour savoir quel compte modifier
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  final Color primaryGreen = const Color(0xFF78B596);

  // Ta règle de validation (8 caractères, lettres + chiffres)
  bool _isPasswordValid(String pass) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(pass);
  }

  void _resetPassword() async {
    String pass = _passwordController.text;
    String confirm = _confirmPasswordController.text;

    if (pass.isEmpty || confirm.isEmpty) {
      _showError("Veuillez remplir tous les champs");
      return;
    }

    if (!_isPasswordValid(pass)) {
      _showError("Le mot de passe doit contenir au moins 8 caractères (lettres et chiffres).");
      return;
    }

    if (pass != confirm) {
      _showError("Les mots de passe ne correspondent pas.");
      return;
    }

    setState(() => _isLoading = true);

    // --- ICI : APPEL API POUR METTRE À JOUR LE MOT DE PASSE ---
    await Future.delayed(const Duration(seconds: 2)); // Simulation

    setState(() => _isLoading = false);

    if (mounted) {
      _showSuccess();
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text(
          "Mot de passe réinitialisé avec succès ! Connectez-vous avec votre nouveau mot de passe.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                // On retourne à l'écran de Login et on vide la pile de navigation
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("SE CONNECTER", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F2),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nouveau mot de passe", 
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Créez un mot de passe robuste pour sécuriser votre compte agent.", 
                style: TextStyle(color: Colors.grey)),
            
            const SizedBox(height: 40),

            _inputField("Nouveau mot de passe", _passwordController),
            const SizedBox(height: 20),
            _inputField("Confirmer le mot de passe", _confirmPasswordController),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("METTRE À JOUR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: _isPasswordHidden,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: IconButton(
              icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}