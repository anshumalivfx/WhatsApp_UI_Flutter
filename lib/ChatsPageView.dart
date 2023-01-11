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

getPhoneNum() {
  return getPhoneNumber;
}

List chatMessage = [
  ChatsMessage(
      imageURL:
          "https://nypost.com/wp-content/uploads/sites/2/2021/02/leatham.jpg?quality=75&strip=all",
      name: "Ben Dover",
      previousMessage: "bro",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://images.complex.com/complex/images/c_fill,dpr_auto,f_auto,q_auto,w_1400/fl_lossy,pg_1/fgpu6alkl1stxe7jeasl/florida-man-chad-mason?fimg-ssr-default",
      name: "Chad the Incel",
      previousMessage: "bro",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://cloudfront-us-east-1.images.arcpublishing.com/gmg/NLP2DZUNYNDV3EE5EOGNCSHHHE.jpg",
      name: "Mike Rofone",
      previousMessage: "Dude No",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://nypost.com/wp-content/uploads/sites/2/2022/01/florida-attack-449.jpg?quality=75&strip=all",
      name: "PDF File",
      previousMessage: "I Hate You",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://globalnews.ca/wp-content/uploads/2016/10/florida.png?resize=696,600",
      name: "Half Head",
      previousMessage: "Nope",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTny1bpx6VFLd4W0CW930fs19tpNncfdJzn7A&usqp=CAU",
      name: "Homeless Jade",
      previousMessage: "Союз Нерушими Республик",
      unseenMessage: "69"),
  ChatsMessage(
      imageURL:
          "https://www.thoughtco.com/thmb/D65eUb56GTdOqjyyhM-lA7pjQks=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Grigory-Rasputin-58addee83df78c345bdfe8d0.jpg",
      name: "Иван Нотов",
      previousMessage: "Коммынизма Совот",
      unseenMessage: "69"),
];

class _ChatsPageViewState extends State<ChatsPageView> {
  var _tapPosition;
  List<String> phoneNumbers = [];
  void fetchContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    contacts.forEach((contact) {
      if (contact.phones == null) return;
      for (var i = 0; i < contact.phones!.length; i++) {
        if (contact.phones?.elementAt(i).value != null)
          phoneNumbers.add(contact.phones!.elementAt(i).value!);
      }
      getPhoneNumber = phoneNumbers;
    });

    phoneNumbers.forEach((element) {
      print("$element");
    });
  }

  @override
  void initState() {
    fetchContacts();
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

      data.forEach((key, value) {});

      var currentUser = FirebaseAuth.instance.currentUser;
    });
    // var documentsDirectory = await getDatabasesPath();
    // String path = join(documentsDirectory, "TestDB.db");
    // await deleteDatabase(path);
    // Database database = await openDatabase(path, version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table

    //   // check if table contacts is already created and if not create it

    //   await db.execute(
    //       'CREATE TABLE contacts (id INTEGER PRIMARY KEY, name TEXT, phone TEXT, imageURL TEXT)');
    //   print("Table created");
    // });
    // this.contacts.forEach((element) async {
    //   // check if contact already exists in the database
    //   var contact = await database.rawQuery(
    //       'SELECT * FROM contacts WHERE name="${element.displayName}";');
    //   if (contact.isEmpty) {
    //     // insert contact into the database
    //     var insert = await database.rawInsert(
    //         'INSERT INTO contacts (name, phone, imageURL) VALUES ("${element.displayName}", "${element.phones.toList()}", "avatar2.png")');
    //     if (insert == 0) {
    //       print("Failed to insert");
    //     } else {
    //       print("Inserted");
    //     }
    //   }

    //   var data = await database.rawQuery('SELECT * FROM contacts;');
    //   print(data);
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
                          color: Colors.green.shade500,
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
