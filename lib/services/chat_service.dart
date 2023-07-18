import 'dart:convert';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatService extends ChangeNotifier {

  final CollectionReference _chats = FirebaseFirestore.instance.collection('Chats');

  Future createChat(Chat chat) async =>
    await _chats.doc(chat.id).set(chat.toMap());

  Stream<Chat?> getChat(String chatId) =>
    _chats.doc(chatId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Chat(
          id: snapshot['id'],
          participantsId: List<String>.from(snapshot['participantsId']),
          messages: List<String>.from(snapshot['messages']),
        );
      } else {
        return null;
      }
    });

  Future sendMessage(String chatId, Message message) async {
    await _chats.doc(chatId).update({
      'messages': FieldValue.arrayUnion([json.encode(message.toMap())]),
    });
  }
}