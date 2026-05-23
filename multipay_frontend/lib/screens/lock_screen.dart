import 'package:flutter/material.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _inputPin = "";
  final String _correctPin = "1234"; // À remplacer par le PIN stocké localement

  // Couleurs Premium MultiPay
  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);

  void _onNumberPress(String number) {
    if (_inputPin.length < 4) {
      setState(() {
        _inputPin += number;
      });
    }

    // Vérification automatique quand on arrive à 4 chiffres
    if (_inputPin.length == 4) {
      _verifyPin();
    }
  }

  void _verifyPin() async {
    await Future.delayed(const Duration(milliseconds: 200)); // Petit délai pour l'effet visuel

    if (_inputPin == _correctPin) {
      // PIN Correct -> On déverrouille l'accès
      if (mounted) {
        Navigator.pop(context, true); 
      }
    } else {
      // PIN Incorrect -> On vibre ou on affiche une erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Code PIN incorrect", textAlign: TextAlign.center),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
      setState(() {
        _inputPin = ""; // On vide pour recommencer
      });
    }
  }

  void _onDelete() {
    if (_inputPin.isNotEmpty) {
      setState(() {
        _inputPin = _inputPin.substring(0, _inputPin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Logo ou Icône de verrouillage
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withOpacity(0.1),
              ),
              child: Icon(Icons.lock_person_outlined, color: primaryGreen, size: 50),
            ),
            const SizedBox(height: 30),
            const Text(
              "Session Verrouillée",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Entrez votre code PIN MultiPay",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 50),

            // Indicateurs de saisie (Dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildDot(index)),
            ),

            const Spacer(),

            // Clavier Numérique
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  _buildKeyboardRow(["1", "2", "3"]),
                  const SizedBox(height: 20),
                  _buildKeyboardRow(["4", "5", "6"]),
                  const SizedBox(height: 20),
                  _buildKeyboardRow(["7", "8", "9"]),
                  const SizedBox(height: 20),
                  _buildKeyboardRow(["", "0", "⌫"]),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Option de secours
            TextButton(
              onPressed: () {
                // Logique de déconnexion si l'agent a oublié son PIN
              },
              child: Text("Utiliser le mot de passe", 
                style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isFilled = index < _inputPin.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? primaryGreen : Colors.transparent,
        border: Border.all(color: isFilled ? primaryGreen : Colors.white24, width: 2),
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: numbers.map((n) {
        if (n == "") return const SizedBox(width: 70);
        return _buildKeyboardButton(n);
      }).toList(),
    );
  }

  Widget _buildKeyboardButton(String label) {
    return InkWell(
      onTap: () => label == "⌫" ? _onDelete() : _onNumberPress(label),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 75,
        height: 75,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
        ),
        child: label == "⌫"
            ? const Icon(Icons.backspace_outlined, color: Colors.white, size: 24)
            : Text(
                label, 
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}