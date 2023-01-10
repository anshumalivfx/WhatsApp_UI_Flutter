import 'package:flutter/material.dart';
import 'package:whatsapp/Call.dart';

class CallView extends StatefulWidget {
  const CallView({Key? key}) : super(key: key);

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  List calls = [
    Calls(
        time: "Yesterday 20:30",
        imageURl:
            "https://globalnews.ca/wp-content/uploads/2016/10/florida.png?resize=696,600",
        name: "Florida Half Head Guy",
        recieved: false),
    Calls(
        time: "Today 15:30",
        imageURl:
            "https://staticg.sportskeeda.com/editor/2022/04/88bfb-16504871358025-1920.jpg",
        name: "Peter",
        recieved: false),
    Calls(
        time: "Today 9:45",
        imageURl:
            "https://m.media-amazon.com/images/M/MV5BMzAzNmU4NjYtY2RlMC00OTA5LWJiNjEtOGNkMGVkYjVhZThiXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_FMjpg_UX1000_.jpg",
        name: "Stewie",
        recieved: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: calls.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: calls[index],
          );
        });
  }
}
