import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.interlocutor});

  final ChatUser interlocutor;

  @override
  Widget build(BuildContext context) {

    String uid = Provider.of<AuthService>(context).currentUser!.uid;
    Provider.of<ChatService>(context).createChat(
      Chat(
        participantsId: [uid,  interlocutor.id],
        messages: [
          'message 1',
          'message 2',
          'message 3',
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(interlocutor.username),
      ),
    );
  }
}