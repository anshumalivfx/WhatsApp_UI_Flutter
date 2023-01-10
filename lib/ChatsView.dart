import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/CallView.dart';
import 'package:whatsapp/ChatsPageView.dart';
import 'package:whatsapp/LoginPage.dart';
import 'package:whatsapp/NewMessage.dart';
import 'package:whatsapp/Status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;

class LogOutAlert extends StatefulWidget {
  const LogOutAlert({super.key});

  @override
  State<LogOutAlert> createState() => _LogOutAlertState();
}

class _LogOutAlertState extends State<LogOutAlert> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut().then((value) => {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPageView()))
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Text("Are You sure you want to log out?"),
      actions: [
        CupertinoButton(
            child: const Text("Yes"),
            onPressed: () {
              _signOut();
            }),
        CupertinoButton(
            child: Text("No", style: TextStyle(color: Colors.grey.shade700)),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

typedef HelloWorld = void Function();

class _ChatsViewState extends State<ChatsView> {
  void handleClick(int item) async {
    switch (item) {
      case 0:
        showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: ((context) {
              return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: const LogOutAlert());
            }));
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
                      onPressed: () {
                        showModalBottomSheet(
                            isDismissible: true,
                            context: context,
                            builder: (context) {
                              var phoneNumber = getPhoneNum();

                              return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: NewMessageView(contacts: phoneNumber));
                            });
                      },
                      icon: Icon(Icons.maps_ugc)),
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
            tabs: [Text("Chats"), Text("Friends"), Text("Calls")],
          ),
          title: Text("Heyyo"),
          backgroundColor: Colors.green,
        ),
        body: TabBarView(
          children: [ChatsPageView(), StatusView(), CallView()],
        ),
      ),
    );
  }
}
