class Transaction {
  final String id;
  final String amount;
  final String currency;
  final String status;
  final String type;
  final String date;

  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      currency: json['currency'],
      status: json['status'],
      type: json['type'],
      date: json['date'],
    );
  }
}
