import 'package:flutter/material.dart';
import 'home_screen.dart';

class SimConfigScreen extends StatelessWidget {
  const SimConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuration SIM")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enregistrez et validez vos numéros pour chaque réseau", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            _buildSimInput("MTN", Colors.yellow[700]!),
            _buildSimInput("Moov", Colors.green[600]!),
            _buildSimInput("Celtiis", Colors.blue[600]!),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, minimumSize: const Size(double.infinity, 50)),
              child: const Text("Créer le compte", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimInput(String label, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey[300]!)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
              child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: TextField(decoration: InputDecoration(hintText: "XX XX XX XX", labelText: "Numéro de téléphone"))),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: const Text("Valider", style: TextStyle(color: Colors.white))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}