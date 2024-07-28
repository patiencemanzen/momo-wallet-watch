// models/goal.dart
class Goal {
  String id;
  String description;
  double targetAmount;
  DateTime targetDate;
  double savedAmount;

  Goal({required this.id, required this.description, required this.targetAmount, required this.targetDate, required this.savedAmount});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      description: json['description'],
      targetAmount: json['targetAmount'],
      targetDate: DateTime.parse(json['targetDate']),
      savedAmount: json['savedAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'targetAmount': targetAmount,
      'targetDate': targetDate.toIso8601String(),
      'savedAmount': savedAmount,
    };
  }
}