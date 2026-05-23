import 'package:flutter/material.dart';
import 'transaction_status_screen.dart';

class ServiceFormScreen extends StatefulWidget {
  final String serviceName;
  final Color themeColor;

  const ServiceFormScreen({
    super.key,
    required this.serviceName,
    required this.themeColor,
  });

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  
  String _selectedOp = 'MTN';
  String _selectedType = "INTERNET";

  // On transforme ces variables en "Getters" pour qu'elles soient accessibles partout
  bool get isCredit => widget.serviceName == "Crédits";
  bool get isForfait => widget.serviceName == "Forfaits";
  bool get isDepot => widget.serviceName == "Dépôts";
  bool get isRetrait => widget.serviceName == "Retraits";
  bool get isPrincipal => isCredit || isForfait || isDepot || isRetrait;

  Color get _opColor {
    if (_selectedOp == 'MTN') return Colors.amber;
    if (_selectedOp == 'MOOV') return Colors.green;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPrincipal ? widget.serviceName : "Paiement ${widget.serviceName}"),
        backgroundColor: isPrincipal ? _opColor : Colors.white,
        foregroundColor: isPrincipal ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: isPrincipal 
          ? _buildMainServicesForm() 
          : _buildLegacyForm(),
      ),
    );
  }

  // --- FORMULAIRE PRINCIPAL (CRÉDIT, FORFAIT, DÉPÔT, RETRAIT) ---
  Widget _buildMainServicesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel("CHOISIR L'OPÉRATEUR"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _opBtn("MTN", Colors.amber),
            _opBtn("MOOV", Colors.green),
            _opBtn("CELTIIS", Colors.blue),
          ],
        ),
        const SizedBox(height: 25),

        if (isForfait) ...[
          _sectionLabel("TYPE DE FORFAIT"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_typeBtn("INTERNET"), _typeBtn("APPEL"), _typeBtn("MAXI")],
          ),
          const SizedBox(height: 25),
        ],

        _sectionLabel("NUMÉRO DU CLIENT"),
        TextFormField(
          controller: _idController,
          keyboardType: TextInputType.phone,
          decoration: _inputDeco("01XXXXXXXX", Icons.phone_android),
        ),

        const SizedBox(height: 25),

        _sectionLabel(isForfait ? "SÉLECTIONNER MONTANT" : "MONTANT (FCFA)"),
        if (isCredit || isForfait) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _quickAmountBtn("100"), 
              _quickAmountBtn("200"), 
              _quickAmountBtn("500"),
              if (isForfait) _quickAmountBtn("1000"),
            ],
          ),
          const SizedBox(height: 10),
        ],

        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          readOnly: isForfait, // On force le choix via les boutons pour Forfait
          decoration: _inputDeco("Saisir le montant", Icons.payments_outlined),
        ),

        const SizedBox(height: 40),
        _mainActionBtn(
          isRetrait ? "INITIER LE RETRAIT" : (isDepot ? "VALIDER LE DÉPÔT" : "ACTIVER"), 
          () => _showRecap(context),
        ),
      ],
    );
  }

  // --- FORMULAIRE FACTURES (CANAL, SBEE...) ---
  Widget _buildLegacyForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: widget.themeColor.withOpacity(0.1),
              child: Icon(Icons.receipt_long, color: widget.themeColor, size: 40),
            ),
          ),
          const SizedBox(height: 30),
          const Text("Identifiant Client", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(hintText: _getHintText(), border: const OutlineInputBorder()),
            validator: (v) => v!.isEmpty ? "Champ obligatoire" : null,
          ),
          const SizedBox(height: 20),
          const Text("Montant (FCFA)", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Ex: 5000", border: OutlineInputBorder()),
            validator: (v) => v!.isEmpty ? "Saisissez le montant" : null,
          ),
          const SizedBox(height: 30),
          _mainActionBtn("VALIDER LE PAIEMENT", _submitForm, color: widget.themeColor),
        ],
      ),
    );
  }

  // --- LOGIQUE RÉCAPITULATIF ---
  void _showRecap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 25, right: 25, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isRetrait ? "INITIATION RETRAIT" : "VÉRIFICATION", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            
            if (isDepot) ...[
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.blue),
                    const SizedBox(width: 15),
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("NOM DU DESTINATAIRE", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text("Moustapha ABDOULAYE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],

            _recapRow("Opérateur", _selectedOp),
            if (isForfait) _recapRow("Type Forfait", _selectedType),
            _recapRow("Numéro", _idController.text),
            _recapRow("Montant", "${_amountController.text} F"),
            
            if (isRetrait) ...[
              const SizedBox(height: 10),
              const Text("⚠️ Attente de validation client sur son téléphone.", style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
            
            const Divider(height: 30),

            // ON AFFICHE LE CODE PIN UNIQUEMENT SI CE N'EST PAS UN RETRAIT
            if (!isRetrait) ...[
              TextField(
                controller: _pinController,
                obscureText: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(letterSpacing: 10, fontSize: 20),
                decoration: const InputDecoration(
                  labelText: "CODE PIN AGENT",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              // MESSAGE POUR LE RETRAIT À LA PLACE DU CODE PIN
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade300)
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Patientez que le client valide sur son téléphone, puis cliquez sur le bouton ci-dessous.",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
            ],
          _mainActionBtn(
              isRetrait ? "CONFIRMER LA RÉCEPTION" : "CONFIRMER ET ENVOYER", 
              () {
                // 1. On ferme d'abord le petiColor.fromARGB(255, 90, 25, 25)s (le BottomSheet)
                // 2. On lance l'écran de succès/échec
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionStatusScreen(
                      operator: _selectedOp,
                      service: widget.serviceName,
                      isSuccess: true, // Simulation de succès
                    ),
                  ),
                );
              }, 
              color: isRetrait ? const Color.fromARGB(255, 77, 136, 9) : Colors.black
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS UI RÉUTILISABLES ---
  Widget _opBtn(String name, Color color) {
    bool isSelected = _selectedOp == name;
    return GestureDetector(
      onTap: () => setState(() => _selectedOp = name),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(child: Text(name, style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _typeBtn(String type) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _opColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? _opColor : Colors.grey.shade300, width: 2),
        ),
        child: Center(child: Text(type, style: TextStyle(color: isSelected ? _opColor : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12))),
      ),
    );
  }

  Widget _quickAmountBtn(String amount) {
    return GestureDetector(
      onTap: () => setState(() => _amountController.text = amount),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.21,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Center(child: Text("$amount F", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11))),
      ),
    );
  }

  Widget _mainActionBtn(String label, VoidCallback action, {Color? color}) {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(backgroundColor: color ?? _opColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  InputDecoration _inputDeco(String hint, IconData icon) => InputDecoration(
    hintText: hint, prefixIcon: Icon(icon, color: _opColor),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  Widget _sectionLabel(String t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)));

  Widget _recapRow(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l), Text(v, style: const TextStyle(fontWeight: FontWeight.bold))]),
  );

  String _getHintText() {
    if (widget.serviceName == "Canal+") return "Numéro de réabonnée";
    if (widget.serviceName == "SBEE") return "Numéro de compteur";
    return "Identifiant Client";
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _showRecap(context);
    }
  }
}