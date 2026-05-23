import 'package:flutter/material.dart';
import 'merchant_config_screen.dart';
import 'reset_password_screen.dart'; // Import indispensable

class OtpScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset; // Pour savoir où diriger après succès

  const OtpScreen({
    Key? key, 
    required this.email, 
    this.isPasswordReset = false // Par défaut, on considère que c'est une inscription
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  final Color pureGreen = const Color(0xFF00A859);

  void _verifyOtp() async {
    if (_otpController.text.length < 4) {
      _showError("Veuillez entrer le code complet");
      return;
    }

    setState(() => _isLoading = true);

    // --- LOGIQUE DE VÉRIFICATION (Simulation) ---
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      if (widget.isPasswordReset) {
        // Si c'est un oubli de mot de passe -> Vers ResetPassword
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(email: widget.email),
          ),
        );
      } else {
        // Si c'est une inscription -> Vers Config Marchand
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MerchantConfigScreen(),
          ),
        );
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(Icons.mark_email_read_outlined, size: 80, color: pureGreen),
            const SizedBox(height: 20),
            const Text("Vérification", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Un code a été envoyé à \n${widget.email}", 
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // Champ de saisie du code
            TextField(
              controller: _otpController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 4, // Limite à 4 chiffres
              style: const TextStyle(fontSize: 28, letterSpacing: 15, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                counterText: "", // Cache le compteur de caractères
                hintText: "0000",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), 
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15), 
                  borderSide: BorderSide(color: pureGreen, width: 2)
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity, 
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pureGreen, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("VÉRIFIER", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            
            TextButton(
              onPressed: () {
                // Logique pour renvoyer le code
              }, 
              child: const Text("Renvoyer le code", style: TextStyle(color: Colors.grey))
            ),
          ],
        ),
      ),
    );
  }
}