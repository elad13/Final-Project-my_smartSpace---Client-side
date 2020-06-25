import 'package:flutter/material.dart';
import './screens/LoginScreen.dart';

void main() => runApp(MyApp());

final logoField = Hero(
  tag: 'logo',
  child: CircleAvatar(
    backgroundColor: Colors.transparent,
    radius: 100.0,
    child: Image.asset('images/smartHomeIcon.jpg'),
  ),
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
      title: 'smartSpace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginScreen(),
    );
    return materialApp;
  }
}
