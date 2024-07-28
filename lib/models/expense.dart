// models/expense.dart
class Expense {
  String id;
  String category;
  double amount;
  DateTime date;

  Expense({required this.id, required this.category, required this.amount, required this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      category: json['category'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}