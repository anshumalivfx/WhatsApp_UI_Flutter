import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatBoxView extends StatefulWidget {
  const ChatBoxView({super.key});

  @override
  State<ChatBoxView> createState() => _ChatBoxViewState();
}

class _ChatBoxViewState extends State<ChatBoxView> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          onAttachmentPressed: _attachment,
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

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _attachment() {
    print("Howdy");
  }
}
