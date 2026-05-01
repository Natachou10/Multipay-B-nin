import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'merchant_config_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool _isPasswordHidden = true;
  
  final TextEditingController _commercialNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final Color primaryGreen = const Color(0xFF78B596);

  // Validation Email avec @ obligatoire
  bool _isEmailValid(String email) {
    return email.contains('@') && email.contains('.');
  }

  bool _isPasswordValid(String pass) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(pass);
  }

  void _submit() {
    String email = _emailController.text.trim();
    String pass = _passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      _showError("Veuillez remplir tous les champs");
      return;
    }

    // Correction demandée : Vérification du format email
    if (!_isEmailValid(email)) {
      _showError("Format d'email invalide (ex: votremail@gmail.com)");
      return;
    }

    if (!isLogin) {
      if (!_isPasswordValid(pass)) {
        _showError("Le mot de passe doit contenir au moins 8 caractères (lettres et chiffres).");
        return;
      }
      if (pass != _confirmPasswordController.text) {
        _showError("Les mots de passe ne correspondent pas.");
        return;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MerchantConfigScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardScreen()));
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70, width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(colors: [Color(0xFF2D764F), Color(0xFFD34C4C)]),
                  ),
                  child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),
                const Text("MultiPay-Bénin", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Gérez vos opérations Mobile Money", style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: 35),

                Container(
                  decoration: BoxDecoration(color: const Color(0xFFF1F3F4), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      _tabButton(Icons.login, "Connexion", isLogin, () => setState(() => isLogin = true)),
                      _tabButton(Icons.person_add_outlined, "Inscription", !isLogin, () => setState(() => isLogin = false)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                if (!isLogin) ...[
                  _inputField("Nom commercial", _commercialNameController, false, TextInputType.text),
                  const SizedBox(height: 18),
                ],

                _inputField("Email", _emailController, false, TextInputType.emailAddress),
                const SizedBox(height: 18),
                
                _inputField("Mot de passe", _passwordController, true, TextInputType.text),

                if (!isLogin) ...[
                  const SizedBox(height: 18),
                  _inputField("Confirmation", _confirmPasswordController, true, TextInputType.text),
                ],

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity, height: 55,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isLogin ? "Se connecter" : "S'inscrire", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(IconData icon, String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isActive ? primaryGreen : Colors.grey),
              const SizedBox(width: 10),
              Text(text, style: TextStyle(fontSize: 16, color: isActive ? Colors.black : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, bool isPass, TextInputType type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: isPass ? _isPasswordHidden : false,
          keyboardType: type,
          style: const TextStyle(fontSize: 17),
          decoration: InputDecoration(
            filled: true, fillColor: const Color(0xFFF1F3F4),
            suffixIcon: isPass 
              ? IconButton(
                  icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                ) 
              : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}