import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUser(ChatUser user) async {
    await _firestore.collection('Users').doc(user.id).set(user.toMap());
  }

  Stream<ChatUser> getUser(String uid) => _firestore.collection('Users')
    .doc(uid).snapshots().map((snapshot) =>
      ChatUser(
        id: uid,
        username: snapshot['username'],
        email: snapshot['email'],
        password: snapshot['password'],
      ),
    );
}