import 'package:flutter/material.dart';

class ChatsMessage extends StatefulWidget {
  String? imageURL;

  String? name;

  String? previousMessage;

  String? unseenMessage;

  String? uid;

  ChatsMessage(
      {Key? key,
      this.imageURL,
      this.name,
      this.previousMessage,
      this.unseenMessage,
      this.uid})
      : super(key: key);

  @override
  _ChatsMessageState createState() => _ChatsMessageState();
}

class _ChatsMessageState extends State<ChatsMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageURL ??
                          "https://p.kindpng.com/picc/s/22-223863_no-avatar-png-circle-transparent-png.png"),
                      fit: BoxFit.cover)),
            ),
            Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(widget.name!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 20,
                      child: Text(
                        widget.previousMessage!,
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
