import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:itribe23/chat_screen.dart';
import 'package:itribe23/components/roundedbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:itribe23/components/constant.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;

  final _auth = FirebaseAuth.instance;
  //making private
  bool showspinner = false; //modal_package

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'animationOfLogo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/itribe.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                //Do something with the user input.
                email = value;
              },
              decoration: kFieldDeclartion.copyWith(
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(color: Colors.grey)),
            ),

            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                //Do something with the user input.
                password = value;
              },
              decoration: kFieldDeclartion.copyWith(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
                colour: Colors.blueAccent,
                text: 'Register',
                Navigation: () async {
                  setState(() {
                    showspinner =
                        true; //spinner aa jayega using modal libraray when user click on register button
                  });
                  try {
                    //if user is succesfully register then this user gets saved in authentication object as current user.
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    setState(() {
                      showspinner =
                          false; //jab create ho jaye toh spinner hat jaye
                    });
                    if (newUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Chat(),
                        ),
                      );
                    }
                  } catch (e) {
                    print(e);
                  }
                }),
            //from roundedbutton.dart
          ],
        ),
      ),
    );
  }
}
