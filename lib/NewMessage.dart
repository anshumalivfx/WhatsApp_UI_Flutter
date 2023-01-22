import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/ChatWindow.dart';
import 'package:firebase_database/firebase_database.dart';

class NewMessageView extends StatefulWidget {
  Map<String, dynamic> contacts;

  NewMessageView({super.key, required this.contacts});

  @override
  _NewMessageViewState createState() => _NewMessageViewState();
}

class _NewMessageViewState extends State<NewMessageView> {
  List<Widget> messages = [];

  @override
  Widget build(BuildContext context) {
    widget.contacts.forEach((key, value) {
      messages.add(
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(value["photoURL"]),
          ),
          title: Text(value["name"]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatWindowView(
                  ChatUserTitle: value["name"],
                  imageURL: value["photoURL"],
                  uuid: value["uid"],
                ),
              ),
            );
          },
        ),
      );
    });
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("New Message"),
      ),
      body: ListView(children: messages),
    );
  }
}
