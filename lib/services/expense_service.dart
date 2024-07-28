// services/expense_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').add(expense.toJson());
  }

  Stream<List<Expense>> getExpenses() {
    return _firestore.collection('expenses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromJson(doc.data())).toList();
    });
  }

  Future<void> updateExpense(String id, Expense expense) async {
    await _firestore.collection('expenses').doc(id).update(expense.toJson());
  }
}