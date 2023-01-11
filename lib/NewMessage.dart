import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whatsapp/ChatWindow.dart';

class NewMessageView extends StatefulWidget {
  List<String> contacts;

  NewMessageView({super.key, required this.contacts});

  @override
  _NewMessageViewState createState() => _NewMessageViewState();
}

class _NewMessageViewState extends State<NewMessageView> {
  List<Widget> messages = [];

  @override
  Widget build(BuildContext context) {
    widget.contacts.forEach((element) {
      messages.add(
        ListTile(
          title: Text(element),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatWindowView(
                        ChatUserTitle: element,
                        imageURL:
                            "https://cdn-icons-png.flaticon.com/512/147/147144.png")));
          },
        ),
      );
    });
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text("New Message"),
      ),
      body: ListView(children: messages),
    );
  }
}
