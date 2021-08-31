import 'package:flutter/material.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation2;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(seconds: 1),
      // lowerBound: 1,
      // upperBound: 100,
      vsync: this,
    );

    animation2 =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);

    controller.forward();

    animation2.addStatusListener((status) {
      //A StatusListener is called when an animation begins, ends, moves forward, or moves reverse, as defined by AnimationStatus.
      if (status == AnimationStatus.completed) {
        //The animation is stopped at the end.
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //The animation is stopped at the beginning.
        controller.forward();
      }
    });
    controller.addListener(() {
      setState(() {});
      //print(controller.value);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation2.value,
      appBar: AppBar(
        leading: Row(children: <Widget>[
          Icon(Icons.arrow_back),
          Flexible(
            child: CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(
                  "https://4.bp.blogspot.com/-Jx21kNqFSTU/UXemtqPhZCI/AAAAAAAAh74/BMGSzpU6F48/s1600/funny-cat-pictures-047-001.jpg"),
            ),
          ),
        ]),
        title: Row(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Itribe Group Chat',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Icon(Icons.call),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Icon(Icons.video_call),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Icon(Icons.more_vert_sharp),
            ),
          ),
        ]),
      ),
    );
  }
}
