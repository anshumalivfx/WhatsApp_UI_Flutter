import 'package:flutter/material.dart';
import 'package:whatsapp/ChatsView.dart';

void main(){
  runApp(MaterialApp(
    initialRoute: 'chats',
    routes: {
      'chats' : (context) => ChatsView()
    },
    debugShowCheckedModeBanner: false,
  ));
}


