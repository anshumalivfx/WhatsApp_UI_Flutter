import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsapp/ChatsView.dart';
import 'package:firebase_database/firebase_database.dart';

class OTPPage extends StatefulWidget {
  String? number;
  OTPPage({Key? key, @required this.number}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController controller = TextEditingController();
  String otp = "";
  String verificationId = "";
  @override
  void initState() {
    super.initState();
    // send OTP to phone number
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.number!,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              // navigate to home page
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ChatsView()));
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          middle: Text(
            "Verification OneStep",
            style: TextStyle(color: Colors.green),
          ),
        ),
        body: ListView(
          children: [
            Container(
              // build OTP recieving UI
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        "Enter your OTP",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Pinput(
                      pinAnimationType: PinAnimationType.rotation,
                      controller: controller,
                      length: 6,
                      obscureText: false,
                      onChanged: (value) {
                        setState(() {
                          otp = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CupertinoButton(
                        color: Colors.green,
                        child: Text(
                          "Verify",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          // verify OTP
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: otp))
                                .then((value) {
                              if (value.user != null) {
                                // navigate to home page

                                final userReference = FirebaseDatabase.instance
                                    .ref()
                                    .child('users');
                                if (value.user!.uid != null) {
                                  userReference.child(value.user!.uid).set({
                                    'uid': value.user!.uid,
                                    'phone': value.user!.phoneNumber,
                                    'imageURL': 'assets/avatar2.png'
                                  });
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatsView()));
                              }
                            });
                          } catch (e) {
                            print(e);
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
