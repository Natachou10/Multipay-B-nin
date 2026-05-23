import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  // Connexion
  static Future<Map<String, dynamic>> connecter(String email, String motDePasse) async {
    return await ApiService.connecter(email, motDePasse);
  }

  // Inscription
  static Future<Map<String, dynamic>> inscrire(Map<String, dynamic> data) async {
    return await ApiService.inscrire(data);
  }

  // Vérifier si connecté
  static Future<bool> estConnecte() async {
    final token = await ApiService.getToken();
    return token != null;
  }

  // Déconnexion
  static Future<void> deconnecter() async {
    await ApiService.supprimerToken();
  }
}