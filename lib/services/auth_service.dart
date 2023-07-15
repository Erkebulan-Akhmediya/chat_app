import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async =>
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async =>
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  void signOut() async {
    await _firebaseAuth.signOut();
  }
}