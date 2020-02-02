import 'package:flutter/material.dart';
import '../main.dart';
import '../objects/User.dart';


import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_screenutil/flutter_screenutil.dart';

const url = //'https://smartspace.cfapps.io/smartspace/users';
    'https://smart-space-server.herokuapp.com/smartspace/users';
Future<User> addNewUser(
    String name, String email, String avatar, String role) async {
  User theUser = new User(
      userName: name, userEmail: email, userAvatar: avatar, userRole: role);
  await http.post(url,
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "email": theUser.userEmail,
        "username": theUser.userName,
        "avatar": theUser.userAvatar,
        "role": theUser.userRole,
      }));
  return theUser;
}

class RegisterScreen extends StatefulWidget {
  String userName;
  static const routeName = '/register';
  RegisterScreen({this.userName});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String userName;
  String userEmail;
  String userAvatar;
  String userRole;

  User newUser;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    var userNameField = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onChanged: (val) => userName = val,
      //onChanged: (val) => theUser.userName = val,
      decoration: InputDecoration(
        hintText: 'user name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (val) => userEmail = val,
      //onChanged: (val) => theUser.userEmail = val,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    var avatarField = TextFormField(
      autofocus: false,
      onChanged: (val) => userAvatar = val,
      //onChanged: (val) => theUser.userAvatar = val,
      decoration: InputDecoration(
        hintText: 'avatar',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var roleField = TextFormField(
      autofocus: false,
      onChanged: (val) => userRole = val,
      //onChanged: (val) => theUser.userRole = val,
      decoration: InputDecoration(
        hintText: 'role(PLAYER)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          this.newUser =
              await addNewUser(userName, userEmail, userAvatar, userRole);
          Navigator.of(context).pop();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      //drawer: AppDrawer(theUser: newUser),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logoField,
            SizedBox(height: 20.0),
            userNameField,
            SizedBox(height: 10.0),
            emailField,
            //SizedBox(height: 10.0),
            //passwordField,
            SizedBox(height: 15.0),
            avatarField,
            SizedBox(height: 15.0),
            roleField,
            signUpButton,
          ],
        ),
      ),
    );
  }
}
