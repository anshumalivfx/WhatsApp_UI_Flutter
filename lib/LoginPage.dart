import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:whatsapp/OTPPage.dart';
import 'package:whatsapp/ChatsView.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:whatsapp/RegistrationPageView.dart';

class LoginPageView extends StatefulWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String verificationId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://png.pngtree.com/png-vector/20221018/ourmid/pngtree-whatsapp-mobile-software-icon-png-image_6315991.png"))),
          ),
          middle: Text(
            "Verification OneStep",
            style: TextStyle(color: Colors.green),
          ),
        ),
        body: ListView(children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        "Enter your Phone Number",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          this.number = number;
                        });
                      },
                      onInputValidated: (bool value) {
                        return;
                      },
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.always,
                      selectorTextStyle: TextStyle(color: Colors.black),
                      initialValue: number,
                      textFieldController: controller,
                      formatInput: false,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputBorder: OutlineInputBorder(),
                      onSaved: (PhoneNumber number) {
                        print('On Saved: $number');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        "By tapping Submit, Message and data rates may apply. Tap for details.",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          child: Center(
                            child: Text("Submit",
                                style: TextStyle(color: Colors.white)),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        print(number.phoneNumber);
                        if (number.phoneNumber == null) {
                          showAlertDialog(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OTPPage(number: number.phoneNumber)));
                        }
                      }),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Center(
                      child: SignInWithAppleButton(onPressed: () async {
                        var credential;
                        try {
                          final appleIdCredential =
                              await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName
                              ]);
                          final oAuthProvider = OAuthProvider('apple.com');
                          credential = oAuthProvider.credential(
                              idToken: appleIdCredential.identityToken,
                              accessToken: appleIdCredential.authorizationCode);
                        } catch (e) {
                          print(e);
                        }
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) {
                            if (value.user != null) {
                              final userReference = FirebaseDatabase.instance
                                  .ref()
                                  .child('users');
                              if (value.user!.uid != null) {
                                userReference.child(value.user!.uid).set({
                                  'uid': value.user!.uid,
                                  'email': value.user!.email,
                                  'fullname': value.user!.displayName,
                                });
                              }
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPageView(
                                              isAppleSignIn: true)));
                            }
                          });
                        } catch (e) {
                          print(e);
                        }
                      }),
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text("No Input"),
    content: Text("Enter a valid Phone Number"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
