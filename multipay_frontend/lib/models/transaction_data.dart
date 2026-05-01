class TransactionData {
  final String id;
  final String operator;
  final String service;
  final String number;
  final String? name;
  final String amount;
  final DateTime dateTime;
  final bool isSuccess;

  TransactionData({
    required this.id,
    required this.operator,
    required this.service,
    required this.number,
    this.name,
    required this.amount,
    required this.dateTime,
    required this.isSuccess,
  });
  String generateRef() {
  return "REF${DateTime.now().millisecondsSinceEpoch}";
}
}