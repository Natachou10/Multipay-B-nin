import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Mise à jour avec ton IP actuelle Wi-Fi 2
  static const String baseUrl = "http://10.0.0.40:5000/api/auth";

  static Future<bool> login(String telephone, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "telephone": telephone,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erreur serveur: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erreur réseau (vérifie ton IP/Pare-feu): $e");
      return false;
    }
  }
}