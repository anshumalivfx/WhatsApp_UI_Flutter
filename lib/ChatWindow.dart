import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatWindowView extends StatefulWidget {
  String? ChatUserTitle;
  String? imageURL;
  String? uuid;
  ChatWindowView(
      {super.key, this.ChatUserTitle, this.imageURL, required this.uuid});

  @override
  _ChatWindowViewState createState() => _ChatWindowViewState();
}

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class _ChatWindowViewState extends State<ChatWindowView> {
  String message = "";

  List chatMessages = [];

  List<Widget> messageList = [];

  late TextEditingController _textEditingController;

  final List<types.Message> _messages = [];

  final _user = types.User(id: FirebaseAuth.instance.currentUser!.uid);

  String recUID = "";

  // fetchMessages() async {
  //   await FirebaseDatabase.instance
  //       .ref("users")
  //       .child(FirebaseAuth.instance.currentUser!.uid)
  //       .child("Chats")
  //       .child(recUID)
  //       .child("messages")
  //       .orderByChild("time")
  //       .limitToLast(100)
  //       .onChildAdded
  //       .listen((event) {
  //     if (event.snapshot.value != null) {
  //       final data = Map<String, dynamic>.from(event.snapshot.value as Map);
  //       _messages.add(types.TextMessage(
  //         author: types.User(id: data["sender"]),
  //         createdAt: data["time"],
  //         id: randomString(),
  //         text: data["message"],
  //       ));
  //       setState(() {}); // <-- call setState here to rebuild widget tree
  //     }
  //   });

  //   _messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  // }

  fetchMessages() async {
    await FirebaseDatabase.instance
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("Chats")
        .child(recUID)
        .child("messages")
        .orderByChild("time")
        .onChildAdded
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        _messages.insert(
            0,
            types.TextMessage(
              author: types.User(id: data["sender"]),
              createdAt: data["time"],
              id: randomString(),
              text: data["message"],
            ));
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();

    recUID = widget.uuid!;

    _textEditingController = TextEditingController();

    fetchMessages();

    _messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            Spacer(),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageURL!),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.ChatUserTitle!),
            Spacer()
          ],
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
            inputBackgroundColor: Color.fromARGB(255, 255, 255, 255),
            inputTextColor: Colors.grey,
            inputBorderRadius: BorderRadius.all(Radius.circular(20)),
            inputContainerDecoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            sendButtonIcon: Icon(Icons.send)),
      ),
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final messageRef = FirebaseDatabase.instance
        .ref("users")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("Chats")
        .child(recUID)
        .child("messages")
        .push();

    await messageRef.set({
      "author": FirebaseAuth.instance.currentUser!.uid,
      "image": widget.imageURL,
      "message": message.text,
      "sender": FirebaseAuth.instance.currentUser!.uid,
      "receiver": FirebaseAuth.instance.currentUser!.displayName.toString(),
      "time": timestamp
    });

    final messageRef2 = FirebaseDatabase.instance
        .ref("users")
        .child(recUID)
        .child("Chats")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("messages")
        .push();

    await messageRef2.set({
      "author": recUID,
      "image": widget.imageURL,
      "message": message.text,
      "sender": FirebaseAuth.instance.currentUser!.uid,
      "receiver": FirebaseAuth.instance.currentUser!.displayName.toString(),
      "time": timestamp
    });

    final textMessage = types.TextMessage(
      author: this._user,
      createdAt: timestamp,
      id: randomString(),
      text: message.text,
    );
  }
}
