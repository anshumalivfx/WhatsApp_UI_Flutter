import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/ChatsView.dart';
import 'package:whatsapp/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatsapp/is_signinwithapple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

Future<void> main() async {
  String? route = 'login';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('User is signed in!');
      route = 'chats';
    } else {
      print('User is currently signed out!');
      route = 'login';
    }
  } catch (e) {
    print(e);
  }

  if (Platform.isAndroid) {
    runApp(MaterialApp(
      initialRoute: route,
      routes: {
        'chats': (context) => ChatsView(),
        'login': (context) => LoginPageView()
      },
      debugShowCheckedModeBanner: false,
    ));
  }

  if (Platform.isIOS) {
    runApp(MaterialApp(
      initialRoute: route,
      routes: {
        'chats': (context) => ChatsView(),
        'login': (context) => LoginPageView()
      },
      debugShowCheckedModeBanner: false,
    ));
  }
}
