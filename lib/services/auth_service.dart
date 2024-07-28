import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<User?> register(String email, String password, String name) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
      });
    }

    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile(String userId, String name, String email) async {
    await _firestore.collection('users').doc(userId).update({
      'name': name,
      'email': email,
    });
  }

  Future<User?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      final userData =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (userData.exists) {
        return firebaseUser;
      }
    }
    return null;
  }
}
