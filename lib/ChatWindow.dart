import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatWindowView extends StatefulWidget {
  String? ChatUserTitle;
  String? imageURL;
  ChatWindowView(
      {super.key, @required this.ChatUserTitle, @required this.imageURL});

  @override
  _ChatWindowViewState createState() => _ChatWindowViewState();
}

class _ChatWindowViewState extends State<ChatWindowView> {
  String message = "";

  late TextEditingController _textEditingController;

  List<Widget> messageList = [];
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            Spacer(),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageURL!),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.ChatUserTitle!),
            Spacer()
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(children: messageList),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
      ),
      bottomSheet: BottomAppBar(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.1113,
          child: Center(
            child: Row(children: [
              CupertinoButton(
                  child: Icon(CupertinoIcons.add), onPressed: () {}),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.67,
                child: CupertinoTextField(
                    autocorrect: false,
                    controller: _textEditingController,
                    placeholder: "Write your message......",
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              IconButton(
                  padding: EdgeInsets.only(bottom: 15, left: 10),
                  onPressed: () {
                    setState(() {
                      messageList.add(
                          ChatBubbleSend(message: _textEditingController.text));
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.arrowtriangle_right_circle_fill,
                    color: Colors.blue,
                    size: 45,
                    textDirection: TextDirection.ltr,
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ChatBubbleSend extends StatelessWidget {
  String message;
  ChatBubbleSend({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          CustomPaint(painter: CustomShape(Colors.blue)),
        ],
      ),
    );
  }
}

class ChatBubbleRecieved extends StatelessWidget {
  String message;
  ChatBubbleRecieved({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(180),
          child: CustomPaint(
            painter: CustomShape(Colors.grey.shade100),
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
      ],
    ));
  }
}
