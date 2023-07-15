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

  Stream<List<ChatUser>> getAllUsers(String uid) {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;
      List<ChatUser> users = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
        Map<String, dynamic> data = document.data();
        if (document.id != uid) {
          users.add(
            ChatUser(
              id: document.id,
              username: data['username'],
              email: data['email'],
              password: data['password'],
            ),
          );
        }
      }
      return users;
    });
  }
}