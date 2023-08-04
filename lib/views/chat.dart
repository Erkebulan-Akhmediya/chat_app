import 'dart:convert';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.interlocutor});

  final ChatUser interlocutor;

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    String uid = Provider.of<AuthService>(context).currentUser!.uid;
    List<String> participantsId = [uid, interlocutor.id];
    participantsId.sort();
    String chatId = participantsId.join('_');

    Provider.of<ChatService>(context).getChat(
      chatId,
    ).listen((chat) async {
      if (chat == null) {
        await Provider.of<ChatService>(context, listen: false).createChat(
          Chat(
            id: chatId,
            participantsId: participantsId,
            messages: [],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(interlocutor.username),
      ),
      body: StreamBuilder<Chat?>(
        stream: Provider.of<ChatService>(context).getChat(chatId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.messages.length,
                    itemBuilder: (context, index) {
                      Message message = Message.fromMap(
                        json.decode(snapshot.data!.messages[index]),
                      );
                      return Container(
                        alignment: uid == message.senderId ? Alignment.topRight : Alignment.topLeft,
                        margin: const EdgeInsets.all(20.0),
                        child: Text(
                          message.message,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          labelText: 'Message',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Provider.of<ChatService>(context, listen: false)
                          .sendMessage(
                            chatId,
                            Message(
                              senderId: uid,
                              receiverId: interlocutor.id,
                              message: _messageController.text,
                              time: DateTime.now(),
                            ),
                          );
                        _messageController.clear();
                      },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}