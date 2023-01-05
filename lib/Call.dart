import 'package:flutter/material.dart';

class Calls extends StatefulWidget {
  String? imageURl;
  bool? recieved;
  String? name;
  String? time;
  Calls({Key? key, this.imageURl, this.time, this.name, this.recieved}) : super(key: key);

  @override
  State<Calls> createState() => _CallsState();
}

class _CallsState extends State<Calls> {
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
                    Text(widget.name!, style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                    Spacer(),
                    Row(
                      children: [
                        
                        widget.recieved! ? Icon(Icons.keyboard_arrow_left_outlined, color: Colors.red) : Icon(Icons.arrow_right, color: Colors.green),
                        
                        Text(widget.time!, style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700
                        ),),
                        
                      ],
                    ),
                    
                  ],
                )),
            Spacer(),
            Container(
              width: 50,
              height: 50,
              child: Icon(widget.recieved! ? Icons.phone_callback : Icons.phone_forwarded, color: Colors.green),

            ),
          ],
        ),
      ),

    );;
  }
}
