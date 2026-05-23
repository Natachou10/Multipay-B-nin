import 'package:flutter/material.dart';

class OperatorPinScreen extends StatefulWidget {
  const OperatorPinScreen({super.key});

  @override
  State<OperatorPinScreen> createState() => _OperatorPinScreenState();
}

class _OperatorPinScreenState extends State<OperatorPinScreen> {
  // États de la page
  String? _selectedOperator; // MTN, Moov ou Celtiis
  int _currentStep = 1; // 1: Choix Opérateur, 2: Saisie PIN
  String _pinBuffer = "";

  // Couleurs
  final Color primaryGreen = const Color(0xFF00A859);
  final Color bgDark = const Color(0xFF0F172A);
  final Color cardDark = const Color(0xFF1E293B);

  // Données des opérateurs
  final List<Map<String, dynamic>> _operators = [
    {"name": "MTN Bénin", "color": const Color(0xFFFFCC00), "icon": Icons.cell_tower},
    {"name": "Moov Africa", "color": const Color(0xFF00D2D3), "icon": Icons.sensors},
    {"name": "Celtiis", "color": const Color(0xFFE84118), "icon": Icons.router},
  ];

  void _onOperatorSelected(String name) {
    setState(() {
      _selectedOperator = name;
      _currentStep = 2;
    });
  }

  void _onNumberPress(String num) {
    if (_pinBuffer.length < 4) {
      setState(() => _pinBuffer += num);
    }
    if (_pinBuffer.length == 4) {
      _finalizePinChange();
    }
  }

  void _finalizePinChange() async {
    // Simulation d'envoi API
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF00A859))),
    );

    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.pop(context); // Fermer loader
      _showSuccess();
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text(
          "Le code PIN pour $_selectedOperator a été mis à jour.",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("TERMINER", style: TextStyle(color: Colors.green)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: Text(_currentStep == 1 ? "Choisir l'opérateur" : "Nouveau PIN $_selectedOperator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep == 2) {
              setState(() {
                _currentStep = 1;
                _pinBuffer = "";
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _currentStep == 1 ? _buildOperatorList() : _buildPinPad(),
      ),
    );
  }

  // --- ÉTAPE 1 : LISTE DES OPÉRATEURS ---
  Widget _buildOperatorList() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sélectionnez le compte à sécuriser",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 30),
          ..._operators.map((op) => Card(
            color: cardDark,
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),
              leading: CircleAvatar(
                backgroundColor: op['color'].withOpacity(0.2),
                child: Icon(op['icon'], color: op['color']),
              ),
              title: Text(op['name'], 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
              onTap: () => _onOperatorSelected(op['name']),
            ),
          )),
        ],
      ),
    );
  }

  // --- ÉTAPE 2 : CLAVIER PIN ---
  Widget _buildPinPad() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Définissez votre nouveau code à 4 chiffres",
            style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 40),
        
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) => Container(
            margin: const EdgeInsets.all(10),
            width: 15, height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index < _pinBuffer.length ? primaryGreen : Colors.white10,
              border: Border.all(color: index < _pinBuffer.length ? primaryGreen : Colors.white24),
            ),
          )),
        ),
        
        const Spacer(),
        
        // Clavier
        Container(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              _buildRow(["1", "2", "3"]),
              _buildRow(["4", "5", "6"]),
              _buildRow(["7", "8", "9"]),
              _buildRow(["", "0", "⌫"]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((l) => _buildKey(l)).toList(),
    );
  }

  Widget _buildKey(String label) {
    return InkWell(
      onTap: () {
        if (label == "⌫") {
          if (_pinBuffer.isNotEmpty) setState(() => _pinBuffer = _pinBuffer.substring(0, _pinBuffer.length - 1));
        } else if (label.isNotEmpty) {
          _onNumberPress(label);
        }
      },
      child: Container(
        width: 80, height: 80,
        alignment: Alignment.center,
        child: label == "⌫" 
          ? const Icon(Icons.backspace_outlined, color: Colors.white)
          : Text(label, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      ),
    );
  }
}