// services/budget_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBudget(Budget budget) async {
    await _firestore.collection('budgets').add(budget.toJson());
  }

  Stream<List<Budget>> getBudgets() {
    return _firestore.collection('budgets').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Budget.fromJson(doc.data())).toList();
    });
  }

  Future<void> updateBudget(String id, Budget budget) async {
    await _firestore.collection('budgets').doc(id).update(budget.toJson());
  }
}
