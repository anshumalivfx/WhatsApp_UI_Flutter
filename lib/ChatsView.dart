import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/CallView.dart';
import 'package:whatsapp/ChatsPageView.dart';
import 'package:whatsapp/LoginPage.dart';
import 'package:whatsapp/NewMessage.dart';
import 'package:whatsapp/RegistrationPageView.dart';
import 'package:whatsapp/Status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

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
      content: const Text("Are You sure you want to log out?"),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    RegistrationPageView(isAppleSignIn: true)));
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
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child:
                                        NewMessageView(contacts: phoneNumber));
                              });
                        },
                        icon: Icon(Icons.maps_ugc)),
                    IconButton(
                        onPressed: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: CupertinoActionSheet(
                                      title: const Text("Select Image"),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          child: const Text("Camera"),
                                          onPressed: () async {
                                            try {
                                              XFile image = ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 50,
                                                      maxWidth: 200,
                                                      maxHeight: 200) as XFile;
                                              if (image != null) {
                                                File file = File(image.path);
                                                print(file.path);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: const Text("Gallery"),
                                          onPressed: () async {
                                            try {
                                              XFile image = ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      imageQuality: 50,
                                                      maxWidth: 200,
                                                      maxHeight: 200) as XFile;
                                              if (image != null) {
                                                File file = File(image.path);
                                                print(file.path);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ));
                              });
                        },
                        icon: const Icon(Icons.camera_enhance)),

                    // IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))

                    PopupMenuButton<int>(
                      onSelected: (item) => handleClick(item),
                      itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                            value: 0, child: Text('Logout')),
                        const PopupMenuItem<int>(
                            value: 1, child: Text('Settings')),
                      ],
                    ),
                  ],
                ),
              )
            ],
            bottom: const TabBar(
              indicator: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))),
              tabs: [Text("Chats"), Text("Friends"), Text("Calls")],
            ),
            title: Text(
              "Heyyo",
            ),
            backgroundColor: Colors.blueAccent),
        body: const TabBarView(
          children: [ChatsPageView(), StatusView(), CallView()],
        ),
      ),
    );
  }
}
