import 'package:flutter/material.dart';
import 'package:whatsapp/ChatsMessage.dart';

class ChatsPageView extends StatefulWidget {
  const ChatsPageView({Key? key}) : super(key: key);

  @override
  State<ChatsPageView> createState() => _ChatsPageViewState();
}

class _ChatsPageViewState extends State<ChatsPageView> {
  
  List chatMessage = [
    ChatsMessage(imageURL: "https://nypost.com/wp-content/uploads/sites/2/2021/02/leatham.jpg?quality=75&strip=all", name: "Ben Dover", previousMessage: "bro", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://images.complex.com/complex/images/c_fill,dpr_auto,f_auto,q_auto,w_1400/fl_lossy,pg_1/fgpu6alkl1stxe7jeasl/florida-man-chad-mason?fimg-ssr-default", name: "Chad the Incel", previousMessage: "bro", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://cloudfront-us-east-1.images.arcpublishing.com/gmg/NLP2DZUNYNDV3EE5EOGNCSHHHE.jpg", name: "Mike Rofone", previousMessage: "Dude No", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://nypost.com/wp-content/uploads/sites/2/2022/01/florida-attack-449.jpg?quality=75&strip=all", name: "PDF File", previousMessage: "I Hate You", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://globalnews.ca/wp-content/uploads/2016/10/florida.png?resize=696,600", name: "Half Head", previousMessage: "Nope", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTny1bpx6VFLd4W0CW930fs19tpNncfdJzn7A&usqp=CAU", name: "Homeless Jade", previousMessage: "Союз Нерушими Республик", unseenMessage: "69"),
    ChatsMessage(imageURL: "https://www.thoughtco.com/thmb/D65eUb56GTdOqjyyhM-lA7pjQks=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Grigory-Rasputin-58addee83df78c345bdfe8d0.jpg", name: "Иван Нотов", previousMessage: "Коммынизма Совот", unseenMessage: "69"),
  ];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatMessage.length,
      itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: Column(
              children: [
                Container(
                  child: chatMessage[index],
                ),
                Divider(
                  color: Colors.grey,
                )
              ],

            ),
          );
      },
    );
  }
}
