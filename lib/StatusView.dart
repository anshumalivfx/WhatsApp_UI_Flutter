import 'package:flutter/material.dart';

class UserStatus extends StatefulWidget {
  String? imageURl;
  String? userName;
  String? time;
  UserStatus({Key? key, this.imageURl, this.userName, this.time}) : super(key: key);

  @override
  _UserStatusState createState() => _UserStatusState();
}

class _UserStatusState extends State<UserStatus> {
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
              child: Column(
                children: [
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),

                    ],
                  )

                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.green
                ),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  image: DecorationImage(
                      image: NetworkImage(widget.imageURl!),
                      fit: BoxFit.cover
                  )
              ),
            ),
            Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userName!, style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                    Spacer(),
                    Text(widget.time!, style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700
                    ),),
                  ],
                )),
          ],
        ),
      ),

    );
  }
}
