import 'package:flutter/material.dart';
import 'otp_screen.dart'; 

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  // Fonction pour envoyer le code (Simulation de l'appel API)
  void _sendResetCode() async {
    String email = _emailController.text.trim();
    
    if (email.isEmpty || !email.contains('@')) {
      _showError("Veuillez entrer un email valide");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // --- ICI : APPEL API RÉEL ---
      // Exemple avec ton futur backend Node.js :
      // var response = await http.post(Uri.parse('$baseUrl/auth/forgot-password'), body: {'email': email});
      
      await Future.delayed(const Duration(seconds: 2)); // Simulation de l'envoi

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Code envoyé à $email"), backgroundColor: Colors.green),
        );
        
        // On redirige vers l'écran OTP pour vérifier le code reçu
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(email: email),
          ),
        );
      }
    } catch (e) {
      _showError("Erreur lors de l'envoi. Vérifiez votre connexion.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Récupération")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mot de passe oublié ?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Entrez l'adresse mail liée à votre compte agent. Un code de vérification vous sera envoyé.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email de l'agent",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendResetCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("ENVOYER LE CODE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Ajoute cette fonction à la fin de ta classe _ForgotPasswordScreenState
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg), 
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating, // Optionnel : pour un look plus moderne
      ),
    );
  }
}