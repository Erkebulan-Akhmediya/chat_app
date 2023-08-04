import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
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
      body: StreamBuilder<List<ChatUser>>(
        stream: Provider.of<UserService>(context).getAllUsers(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
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
              return const Center(
                child: Text('No users yet'),
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