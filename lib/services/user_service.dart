import 'package:chat_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void saveUser(ChatUser user) async {
    await _db.collection('Users').doc(user.id).set(user.toMap());
  }

  Stream<ChatUser> getUser(String id) => _db.collection('Users').doc(id)
    .snapshots().map(
      (snapshot) => ChatUser(
        id: id,
        username: snapshot['username'],
        email: snapshot['email'],
        password: snapshot['password'],
      ),
    );
}