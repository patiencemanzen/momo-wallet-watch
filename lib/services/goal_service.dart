// services/goal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/goal.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addGoal(Goal goal) async {
    await _firestore.collection('goals').add(goal.toJson());
  }

  Stream<List<Goal>> getGoals() {
    return _firestore.collection('goals').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Goal.fromJson(doc.data())).toList();
    });
  }

  Future<void> updateGoal(String id, Goal goal) async {
    await _firestore.collection('goals').doc(id).update(goal.toJson());
  }
}
