import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  Future<List<Contact>?> getUserContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      return contacts;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>?>(
        future: getUserContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Contact contact = snapshot.data![index];
                return ListTile(
                  title: Text('${contact.name.first} ${contact.name.last}'),
                  subtitle: Text(contact.phones.isNotEmpty ? contact.phones[0].number : ''),
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

}