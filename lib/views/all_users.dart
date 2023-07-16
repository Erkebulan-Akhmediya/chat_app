import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:chat_app/views/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<AuthService>(context).currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          return StreamBuilder<List<ChatUser>>(
            stream: Provider.of<UserService>(context).getAllUsers(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              interlocutor: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Text(snapshot.data![index].username),
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
      floatingActionButton: StreamBuilder<List<ChatUser>>(
        stream: Provider.of<UserService>(context).getAllUsers(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ElevatedButton(
              onPressed: () {
                Provider.of<ChatService>(context, listen: false).getChat(
                  [uid, snapshot.data![0].id],
                ).listen((chat) {
                  if (chat != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('chat is found'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('chat is not found'),
                      ),
                    );
                  }
                });
              },
              child: const Text('find chat with \'another user\''),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}