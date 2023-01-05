import 'package:flutter/material.dart';
import 'package:whatsapp/StatusView.dart';


class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {

  List status = [
    UserStatus(imageURl: "https://ih1.redbubble.net/image.3754430867.3118/st,small,507x507-pad,600x600,f8f8f8.jpg", userName: "GigaChad", time: "Today/17:04"),
    UserStatus(imageURl: "https://pbs.twimg.com/profile_images/1191723131792179202/ifpxmIOV_400x400.png", userName: "Regular Chad", time: "Today / 20:23",),
    UserStatus(imageURl: "https://upload.wikimedia.org/wikipedia/commons/c/ca/Osama_bin_Laden_portrait.jpg", userName: "Osama", time: "09/11/2001/15:15")
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
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
                          ClipRect(

                            child: Container(
                              width: 20,
                              height: 20,
                              child: Center(child: Text("+", style: TextStyle(
                                  color: Colors.white
                              ),)),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      image: DecorationImage(
                          image: NetworkImage("https://i.kym-cdn.com/entries/icons/facebook/000/026/152/gigachad.jpg"),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Status", style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                        Spacer(),
                        Text("Tap or add status update", style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade700
                        ),),

                      ],
                    )),


              ],
            ),
          ),

        ),
        ListView.builder(
            shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Column(
              children: [

                status.isEmpty ? Container() : Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(10),
                      child: Text("Recent Updates",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300
                      ),
                    ),
                    Container(
                      height: 500,
                      child: ListView.builder(
                        itemCount: status.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: status[index],
                          );
                        },
                      ),
                    ),

                  ],
                )
              ],
            );
          },
        )
      ],
    );
  }
}
