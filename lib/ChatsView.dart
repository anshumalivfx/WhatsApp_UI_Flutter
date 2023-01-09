import 'package:flutter/material.dart';
import 'package:whatsapp/CallView.dart';
import 'package:whatsapp/ChatsPageView.dart';
import 'package:whatsapp/LoginPage.dart';
import 'package:whatsapp/Status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

typedef HelloWorld = void Function();

class _ChatsViewState extends State<ChatsView> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then((value) => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPageView()))
        });
  }

  void handleClick(int item) async {
    switch (item) {
      case 0:
        await _signOut();
        break;
      case 1:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.camera_enhance)),

                  IconButton(onPressed: () {}, icon: Icon(Icons.search)),

                  // IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
                  PopupMenuButton<int>(
                    onSelected: (item) => handleClick(item),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(value: 0, child: Text('Logout')),
                      PopupMenuItem<int>(value: 1, child: Text('Settings')),
                    ],
                  ),
                ],
              ),
            )
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white))),
            tabs: [Text("Chats"), Text("Status"), Text("Calls")],
          ),
          title: Text("WhatsApp"),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: [ChatsPageView(), StatusView(), CallView()],
        ),
      ),
    );
  }
}
