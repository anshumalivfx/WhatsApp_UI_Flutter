import 'package:flutter/material.dart';
import 'package:whatsapp/CallView.dart';
import 'package:whatsapp/ChatsPageView.dart';
import 'package:whatsapp/Status.dart';



class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          actions: [
            Container(
              child: Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.camera_enhance)),

                  IconButton(onPressed: (){}, icon: Icon(Icons.search)),

                  IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
                ],
              ),
            )
          ],
          bottom: TabBar(

            indicator: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.white)
                  )

              ),
            tabs: [
              Text("Chats"),
              Text("Status"),
              Text("Calls")
            ],

          ),
          title: Text("WhatsApp"),
          backgroundColor: Colors.green,


        ),
      body: TabBarView(
        children: [
          ChatsPageView(),
          StatusView(),
          CallView()
        ],
      ),

      ),
    );
  }
}


