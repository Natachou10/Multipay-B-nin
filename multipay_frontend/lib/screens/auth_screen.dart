import 'package:flutter/material.dart';
import 'home_screen.dart'; // On créera ce fichier après

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Multi-Pay Bénin", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green[700],
          bottom: const TabBar(
            tabs: [Tab(text: "Connexion"), Tab(text: "Inscription")],
            labelColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            LoginForm(),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}

// Widget simplifié pour le formulaire de login
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: "Numéro de téléphone", border: OutlineInputBorder())),
          const SizedBox(height: 15),
          const TextField(obscureText: true, decoration: InputDecoration(labelText: "Mot de passe", border: OutlineInputBorder())),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], minimumSize: const Size(double.infinity, 50)),
            child: const Text("SE CONNECTER", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});
  @override
  Widget build(BuildContext context) { return const Center(child: Text("Interface Inscription")); }
}