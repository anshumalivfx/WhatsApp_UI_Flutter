import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kg_charts/kg_charts.dart';

class FindingScreen extends StatefulWidget {
  const FindingScreen({super.key});

  @override
  State<FindingScreen> createState() => _FindingScreenState();
}

class _FindingScreenState extends State<FindingScreen>
    with SingleTickerProviderStateMixin {
  Animation<double>? animation; //animation variable for circle 1
  AnimationController? animationcontroller;
  Animation<double>? opacAnim;
  @override
  void initState() {
    animationcontroller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    //here we have to vash vsync argument, there for we use "with SingleTickerProviderStateMixin" above
    //vsync is the ThickerProvider, and set duration of animation

    animationcontroller!.repeat();
    //repeat the animation controller

    animation = Tween<double>(begin: 0, end: 200).animate(animationcontroller!);
    opacAnim = Tween<double>(begin: 1, end: 0).animate(animationcontroller!);
    //set the begin value and end value, we will use this value for height and width of circle

    opacAnim!.addListener(() {
      setState(() {});
    });
    animation!.addListener(() {
      setState(() {});
      //set animation listiner and set state to update UI on every animation value change
    });

    super.initState();
  }

  @override
  void dispose() {
    animationcontroller!.dispose();
    super.dispose();
    //destory anmiation to free memory on last
  }

  @override
  Widget build(BuildContext context) {
    // create a rotating animated radar
    return Container(
      child: Center(
          child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                height: 300,
                child: Container(
                  child: Center(
                      child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green.shade500),
                    height: 10,
                    width: 10,
                  )),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, //making box to circle
                      color: Colors.transparent,
                      border: Border.all(
                        color:
                            Colors.green.shade500.withOpacity(opacAnim!.value),
                      ) //background of container
                      ),
                  height: animation!.value, //value from animation controller
                  width: animation!.value, //value from animation controller
                ),
              ),
            ],
          ),
          Text("Finding nearby users..."),
          CupertinoButton(
              child: Container(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      )),
    );
  }
}
