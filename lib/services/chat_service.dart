import 'package:chat_app/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {

  final CollectionReference _chats = FirebaseFirestore.instance.collection('Chats');

  Future createChat(Chat chat) async =>
    await _chats.add(chat.toMap());

  Stream<Chat?> getChat(List<String> participantsId) {
    Query query = _chats.where('participantsId', isEqualTo: participantsId..sort());
    Stream<QuerySnapshot> querySnapshot = query.snapshots();
    Stream<Chat?> chatStream = querySnapshot.map((snapshot) {
      List<QueryDocumentSnapshot> queryDocumentSnapshotList = snapshot.docs;
      if (queryDocumentSnapshotList.isNotEmpty) {
        QueryDocumentSnapshot queryDocumentSnapshot = queryDocumentSnapshotList[0];
        return Chat(
          participantsId: queryDocumentSnapshot['participantsId'],
          messages: queryDocumentSnapshot['messages'],
        );
      } else {
        return null;
      }
    });
    return chatStream;
  }
}