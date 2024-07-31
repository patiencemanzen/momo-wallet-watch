// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:momo_wallet_watcher/models/budget.dart';
import 'package:momo_wallet_watcher/models/expense.dart';
import 'package:momo_wallet_watcher/models/goal.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Expense>> getExpenses() async {
    QuerySnapshot snapshot = await _firestore.collection('expenses').get();
    return snapshot.docs
        .map((doc) => Expense(
              id: doc.id,
              amount: doc['amount'],
              date: (doc['date'] as Timestamp).toDate(),
              category: doc['category'],
            ))
        .toList();
  }

  Future<List<Budget>> getBudgets() async {
    QuerySnapshot snapshot = await _firestore.collection('budgets').get();
    return snapshot.docs
        .map((doc) => Budget(
              id: doc.id,
              category: doc['category'], // Include the category field here
              amount: doc['amount'],
              startDate: (doc['startDate'] as Timestamp).toDate(),
              endDate: (doc['endDate'] as Timestamp).toDate(),
            ))
        .toList();
  }

  Future<List<Goal>> getGoals() async {
    QuerySnapshot snapshot = await _firestore.collection('goals').get();
    return snapshot.docs
        .map((doc) => Goal(
              id: doc.id,
              description: doc['description'],
              targetAmount: doc['targetAmount'],
              savedAmount: doc['savedAmount'],
              targetDate: (doc['targetDate'] as Timestamp).toDate(),
            ))
        .toList();
  }
}
