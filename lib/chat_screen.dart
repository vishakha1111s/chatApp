import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itribe23/components/constant.dart';

final _clouldFireStore = FirebaseFirestore.instance;
late User loggedUser; //firebaseuser
late bool isMe;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;

  late String message; //message which user sends

  final messageController = TextEditingController();

  void getUserInput() async {
    final user = await _auth.currentUser;
    try {
      if (user != null) {
        //user aa gya ki ni wo check krre
        loggedUser = user;
        // print(loggedUser);
      }
    } catch (e) {
      print(e);
    }
  }

  late AnimationController controller;
  late Animation animation2;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    getUserInput();
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            messageBuilder(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      //sending both msg and email both.
                      messageController
                          .clear(); //for clearing text when we press send
                      _clouldFireStore.collection('users').add({
                        'timestamp': FieldValue
                            .serverTimestamp(), //taking timestamp according to server
                        'text': message,
                        'sender': loggedUser.email
                      });
                      //saving data in firebase.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BubbleText extends StatelessWidget {
  var messageText;
  var messageSender;
  bool isMe;

  BubbleText({this.messageText, this.messageSender, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(messageSender),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 30.0 : 0),
                topRight: Radius.circular(isMe ? 0.0 : 30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            color: isMe ? Colors.lightBlueAccent : Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                '$messageText',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class messageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _clouldFireStore.collection('users').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        dynamic messages = snapshot
            .data!
            .docs //we are reversing it because it was reversed
            .reversed; //snapshot= is async snapshot, data == query snapshot, doc==data
        List<BubbleText> messagesWidgets = [];
        for (var message in messages) {
          final messageData = Map<String, dynamic>.from(message.data()); //
          final messageText = messageData['text'];
          final messageSender = messageData['sender'];
          final currentuser = loggedUser.email; //checking if current user

          final messageWidgets = BubbleText(
            messageText: messageText,
            messageSender: messageSender,
            isMe:
                currentuser == messageSender, //if currentuser then blue colour
          );

          messagesWidgets.add(messageWidgets);
        }
        return Expanded(
          child: ListView(
            reverse: //we are reversing here so that msg screen p aajaye apne aap or upar bhi ek baar reverse karre hai. taki balance ho jaye
                true, //we are using list so that we can list the elements in scrolling view
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            children: messagesWidgets,
          ),
        );
      },
    );
  }
}
