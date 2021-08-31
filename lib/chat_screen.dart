import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(children: <Widget>[
          Icon(Icons.arrow_back),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 1.0,
            ),
          )
        ]),
        title: Text('Itribe Group Chat'),
      ),
    );
  }
}
