import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
      messages.add(ListTile(
        title: Text(element),
      ));
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
