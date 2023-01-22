import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp/ChatWindow.dart';
import 'package:whatsapp/ChatsMessage.dart';
import 'package:whatsapp/FindingScreen.dart';
import 'dart:math';
import 'package:sqflite/sqflite.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class ChatsPageView extends StatefulWidget {
  const ChatsPageView({Key? key}) : super(key: key);
  @override
  State<ChatsPageView> createState() => _ChatsPageViewState();
}

var getPhoneNumber;

Map<String, dynamic> availablePhoneNumbers = {};

getPhoneNum() {
  return availablePhoneNumbers;
}

class _ChatsPageViewState extends State<ChatsPageView> {
  var _tapPosition;
  var users;
  var validPhoneNumber;

  List chatMessage = [];

  List<String> phoneNumbers = [];
  void fetchContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    contacts.forEach((contact) {
      if (contact.phones == null) return;
      for (var i = 0; i < contact.phones!.length; i++) {
        if (contact.phones?.elementAt(i).value != null)
          // remove special characters and spaces
          validPhoneNumber = contact.phones
              ?.elementAt(i)
              .value!
              .replaceAll(RegExp(r'[^0-9]'), '')
              .replaceAll(RegExp(r' '), '');

        // add to phoneNumbers
        phoneNumbers.add("+$validPhoneNumber");
      }
      getPhoneNumber = phoneNumbers;
    });
  }

  fetchMessages() {
    var currentUser = FirebaseAuth.instance.currentUser;

    FirebaseDatabase.instance
        .ref("users")
        .child(currentUser!.uid)
        .child("Chats")
        .onValue
        .listen((event) {
      String name = "";
      String imageURL = "";
      String previousMessage = "";
      String uid = "";
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      data.forEach((key, value) {
        final data = Map<String, dynamic>.from(
          value as Map,
        );
        uid = key;
        data.forEach((key, value) {
          final finalData = Map<String, dynamic>.from(
            value as Map,
          );
          finalData.forEach((key, value) {
            setState(() {
              name = value["reciever"] ?? "Unknown";
              previousMessage = value["message"];
            });
            imageURL = value["image"];
          });
        });
      });

      setState(() {
        chatMessage.add(ChatsMessage(
          name: name,
          imageURL: imageURL,
          previousMessage: previousMessage,
          unseenMessage: "",
          uid: uid,
        ));
      });
    });
  }

  @override
  void initState() {
    fetchContacts();
    fetchContact();
    fetchMessages();
    super.initState();
  }

  fetchContact() async {
    // List<Contact> contacts = await FlutterContacts.getContacts();
    // contacts.forEach((element) {
    //   print(element.phones);
    // });

    // var data

    // FirebaseDatabase.instance.ref().child('users').once().then((snapshot) {
    //   var data = snapshot.snapshot.value;

    // });

    FirebaseDatabase.instance.ref("users").onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      users = data;

      // check if users phone number registered in getPhoneNumber
      // if yes then add to chatMessage
      Map<String, dynamic> available = {};
      for (var i = 0; i < getPhoneNumber.length; i++) {
        users.forEach((key, value) {
          if (value['phone'] == getPhoneNumber[i]) {
            available[key] = value;
          } else {
            print("No");
          }
        });
      }

      availablePhoneNumbers = available;

      var currentUser = FirebaseAuth.instance.currentUser;
    });
  }

  bool finding = false;

  // List chatMessage = [];
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showContextBox(var val) {}

  @override
  Widget build(BuildContext context) {
    return chatMessage.isNotEmpty
        ? ListView.builder(
            itemCount: chatMessage.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: Column(
                  children: [
                    ListTile(
                      title: chatMessage[index],
                      trailing: CupertinoContextMenu(actions: [
                        CupertinoContextMenuAction(
                          child: Text("Delete Chat"),
                          onPressed: () {
                            chatMessage.remove(chatMessage[index]);

                            Navigator.pop(context);
                          },
                        )
                      ], child: Icon(CupertinoIcons.ellipsis)),
                      onTap: () {
                        _storePosition;
                        var contact = chatMessage[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatWindowView(
                                      ChatUserTitle: contact.name,
                                      imageURL: contact.imageURL,
                                      uuid: contact.uid,
                                    )));
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                    )
                  ],
                ),
              );
            },
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: CupertinoButton(
                  child: Container(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Center(
                          child: Text(
                        "Find a new Bestie",
                        style: TextStyle(color: Colors.white),
                      )),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          findFriend();
                          return CupertinoAlertDialog(content: FindingScreen());
                        });
                  }),
            ),
          );
  }

  findFriend() async {
    var ranNumber = Random();
    FirebaseDatabase.instance.ref("users").onValue.listen((event) {
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );

      print(ranNumber.nextInt(data.length));

      var currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        var currentUserID = currentUser.uid;
        var currentUserData = data[currentUserID];
        var currentUserDataMap = Map<String, dynamic>.from(currentUserData);
        var currentUserImage = currentUserDataMap["imageURL"];
        var currentUserUsername = currentUserDataMap["username"];

        var randomUser = data[ranNumber.nextInt(data.length)];
        var randomUserDataMap = Map<String, dynamic>.from(randomUser);
        var randomUserImage = randomUserDataMap["imageURL"];
        var randomUserUsername = randomUserDataMap["username"];

        setState(() {
          chatMessage.add(ChatsMessage(
              imageURL: randomUserImage,
              name: randomUserUsername,
              previousMessage: "Hey",
              unseenMessage: "69"));
        });
      }
    });
  }
}

class ContextMenuChat extends StatefulWidget {
  var m_chatMessage;
  ContextMenuChat({super.key, required this.m_chatMessage});

  @override
  _ContextMenuChatState createState() => _ContextMenuChatState();
}

class _ContextMenuChatState extends State<ContextMenuChat> {
  @override
  Widget build(BuildContext context) {
    var user = widget.m_chatMessage;

    return CupertinoContextMenu(
        actions: [CupertinoContextMenuAction(child: Text("Delete Chat"))],
        child: Container(child: widget.m_chatMessage));
  }
}
