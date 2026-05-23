import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class MerchantConfigScreen extends StatefulWidget {
  const MerchantConfigScreen({super.key});

  @override
  State<MerchantConfigScreen> createState() => _MerchantConfigScreenState();
}

class _MerchantConfigScreenState extends State<MerchantConfigScreen> {
  final Color primaryGreen = const Color(0xFF78B596);
  bool _isLoading = false;

  final TextEditingController _mtnNumeroController = TextEditingController();
  final TextEditingController _mtnPinController = TextEditingController();
  final TextEditingController _moovNumeroController = TextEditingController();
  final TextEditingController _moovPinController = TextEditingController();
  final TextEditingController _celtiisNumeroController = TextEditingController();
  final TextEditingController _cetiiisPinController = TextEditingController();

  void _valider() async {
    setState(() => _isLoading = true);

    final comptes = [];

    if (_mtnNumeroController.text.isNotEmpty) {
      comptes.add({'operateur': 'MTN', 'numero': _mtnNumeroController.text});
    }
    if (_moovNumeroController.text.isNotEmpty) {
      comptes.add({'operateur': 'MOOV', 'numero': _moovNumeroController.text});
    }
    if (_celtiisNumeroController.text.isNotEmpty) {
      comptes.add({'operateur': 'CELTIIS', 'numero': _celtiisNumeroController.text});
    }

    if (comptes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configurez au moins un opérateur'), backgroundColor: Colors.redAccent)
      );
      setState(() => _isLoading = false);
      return;
    }

    final result = await ApiService.configurerCompteOperateur(comptes);

    setState(() => _isLoading = false);

    if (result['message'] == 'Comptes opérateurs configurés') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Erreur'), backgroundColor: Colors.redAccent)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),
      appBar: AppBar(
        title: const Text("Configuration Marchand", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dernière étape !", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Configurez vos accès opérateurs pour commencer à gérer vos flux.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            _buildOperatorConfig("MTN Bénin", Colors.amber, Icons.star, _mtnNumeroController, _mtnPinController),
            _buildOperatorConfig("Moov Africa", Colors.green, Icons.eco, _moovNumeroController, _moovPinController),
            _buildOperatorConfig("Celtiis", Colors.blue, Icons.waves, _celtiisNumeroController, _cetiiisPinController),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _valider,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("VALIDER MON INSCRIPTION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorConfig(String label, Color color, IconData icon,
      TextEditingController numeroController, TextEditingController pinController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 17)),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: numeroController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: InputDecoration(
              labelText: "N° Marchand $label",
              hintText: "Ex: 01xxxxxxxx",
              prefixIcon: const Icon(Icons.phone_android, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: InputDecoration(
              labelText: "Code PIN MoMo (5 chiffres)",
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              filled: true,
              fillColor: const Color(0xFFF8F9FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}