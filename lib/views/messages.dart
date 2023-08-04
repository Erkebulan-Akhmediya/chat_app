import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {

    String uid = Provider.of<AuthService>(context).currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<List<Chat>?>(
        stream: Provider.of<ChatService>(context).getAllChats(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  List<String> participantsId = snapshot.data![index].participantsId;
                  participantsId.remove(uid);
                  String interlocutorId = participantsId[0];
                  return StreamBuilder<ChatUser>(
                    stream: Provider.of<UserService>(context).getUser(interlocutorId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  interlocutor: snapshot.data!,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            snapshot.data!.username,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No messages yet'),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}