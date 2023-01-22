import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/ChatsView.dart';

class RegistrationPageView extends StatefulWidget {
  bool? isAppleSignIn;

  RegistrationPageView({super.key, this.isAppleSignIn});

  @override
  State<RegistrationPageView> createState() => _RegistrationPageViewState();
}

class _RegistrationPageViewState extends State<RegistrationPageView> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  var imageURL =
      "https://www.pngall.com/wp-content/uploads/12/Avatar-PNG-Image.png";

  var loading = false;

  _uploadImage(File image) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("profileImages")
          .child(FirebaseAuth.instance.currentUser!.uid);
      await ref.putFile(image);
      imageURL = await ref.getDownloadURL();

      await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageURL);

      print(FirebaseAuth.instance.currentUser!.photoURL);
    } catch (e) {
      print(e);
    }
  }

  _getFromGallery() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        setState(() {
          loading = true;
        });
        await _uploadImage(file);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  _getFromCamera() async {
    try {
      XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        File file = File(pickedFile.path);

        setState(() {
          loading = true;
        });
        await _uploadImage(file);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  bool doesProfilePhotoExist() {
    if (FirebaseAuth.instance.currentUser!.photoURL == null) {
      return false;
    } else {
      imageURL = FirebaseAuth.instance.currentUser!.photoURL!;
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    var name = FirebaseAuth.instance.currentUser!.displayName;
    var phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    _nameController = TextEditingController(text: name);
    _phoneNumberController = TextEditingController(text: phoneNumber);
    doesProfilePhotoExist();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar:
            CupertinoNavigationBar(middle: Text("Finishing Your Profile")),
        child: Center(
            child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: this.loading
                      ? CupertinoActivityIndicator(animating: true, radius: 50)
                      : Container(
                          child: CupertinoButton(
                              child: Container(
                                child: Container(
                                    padding: EdgeInsets.all(30),
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue.shade500),
                                      child: Icon(Icons.add_a_photo_outlined,
                                          color: Colors.white, size: 20),
                                    )),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(imageURL),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.blue.shade500, width: 5),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.5,
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoActionSheet(
                                        title: Text("Select Image"),
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: Text("Gallery"),
                                            onPressed: () {
                                              _getFromGallery();
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text("Camera"),
                                            onPressed: () {
                                              _getFromCamera();
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    });
                              })),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: CupertinoTextField(
                    controller: _nameController,
                    placeholder: "Enter your name",
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 224, 223, 223),
                            width: 2),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
            widget.isAppleSignIn!
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: CupertinoTextField(
                      placeholder: "Enter your Phone Number",
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 224, 223, 223),
                              width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      controller: _phoneNumberController,
                    ),
                  )
                : Container(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: CupertinoTextField(
                placeholder: "Enter your Name",
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 224, 223, 223), width: 2),
                    borderRadius: BorderRadius.circular(20)),
                controller: _nameController,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: CupertinoButton(
                  color: Colors.blue.shade500,
                  child: Text("Finish"),
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Error"),
                              content: Text("Please enter your name"),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                      return;
                    } else {
                      setState(() {
                        loading = true;
                      });
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(_nameController.text);
                      await FirebaseDatabase.instance
                          .ref()
                          .child("users")
                          .child(FirebaseAuth.instance.currentUser!.uid)
                          .update({
                        "name": _nameController.text,
                        "photoURL": FirebaseAuth.instance.currentUser!.photoURL,
                        "uid": FirebaseAuth.instance.currentUser!.uid,
                        "phone": widget.isAppleSignIn!
                            ? _phoneNumberController.text
                            : FirebaseAuth.instance.currentUser!.phoneNumber,
                      });
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ChatsView()));
                    }
                  }),
            )
          ],
        )));
  }
}
