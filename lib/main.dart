import 'package:flutter/material.dart';
import 'package:itribe23/chat_screen.dart';
import 'package:itribe23/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  //
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: RegistrationScreen(),
    );
  }
}
