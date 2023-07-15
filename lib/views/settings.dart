import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    String? uid = Provider.of<AuthService>(context).currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<ChatUser>(
              stream: Provider.of<UserService>(context).getUser(uid!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.username);
                } else {
                  return const LinearProgressIndicator();
                }
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthService>(context, listen: false).signOut();
              },
              child: const Text('Sign out'),
            )
          ],
        ),
      ),
    );
  }
}