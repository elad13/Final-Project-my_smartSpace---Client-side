import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../objects/User.dart';

import '../main.dart';
import './RegisterScreen.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DoorsScreen.dart';

Future<String> CreateAlertDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("The username or the password is incorrect."),
          actions: <Widget>[
            MaterialButton(
              elevation: 5.0,
              child: Text("ok"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            )
          ],
        );
      });
}

Future<User> login(
    String userEmail, String userPassword, BuildContext context) async {
  User theUser = new User.empty();
  var result, convert, name;

  String loginUrl =
      'https://smart-space-server.herokuapp.com/smartspace/users/login/$userPassword/$userEmail';
  result = await http
      .get(Uri.encodeFull(loginUrl), headers: {"Accept": "application/json"});

  if (result.statusCode == 200) {
    convert = json.decode(result.body);

    name = convert['username'];
    if (name != null) {
      theUser.userEmail = convert['key']['email'];
      theUser.userName = convert['username'];
      theUser.userAvatar = convert['avatar'];
      theUser.userRole = convert['role'];
      theUser.isCheckin = false;
    }
  } else {
    CreateAlertDialog(context);
    theUser = null;
    throw Exception('Failed input details.');
  }

  return theUser;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User theUser;
  String userEmail, userPassword;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    var emailField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (val) => userEmail = val,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      onChanged: (val) => userPassword = val,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          theUser = await login(userEmail, userPassword, context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoorsScreen(theUser)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final orLabel = Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.black12,
                      Colors.black,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: 100.0,
              height: 1.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                "Or use",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.black12,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: 100.0,
              height: 1.0,
            ),
          ],
        ));

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final facebookButton = Padding(
      padding: EdgeInsets.only(top: 10.0, right: 40.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlue[900],
          ),
          child: new Icon(
            FontAwesomeIcons.facebookF,
            color: Colors.white,
          ),
        ),
      ),
    );

    final googleButton = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.lightBlue[900],
          ),
          child: new Icon(
            FontAwesomeIcons.google,
            color: Colors.white,
          ),
        ),
      ),
    );

    final googleFacebookLoginButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        facebookButton,
        googleButton,
      ],
    );

    final noAccountLabel = Padding(
      padding: EdgeInsets.only(top: 5, left: 5.0, right: 5.0),
      child: Text(
        "DON'T HAVE AN ACCOUNT?",
        style: TextStyle(
          color: Colors.lightBlue[900],
          fontSize: 15.0,
        ),
      ),
    );

    final signUpButton = Padding(
      padding: EdgeInsets.only(top: 5, left: 5.0, right: 5.0),
      child: FlatButton(
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: Colors.lightBlue[900],
            fontSize: 15.0,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        },
      ),
    );

    final createAccountButton = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        noAccountLabel,
        signUpButton,
      ],
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logoField,
            SizedBox(height: 20.0),
            emailField,
            SizedBox(height: 10.0),
            passwordField,
            SizedBox(height: 15.0),
            loginButton,
            //forgotLabel,
            //orLabel,
            //googleFacebookLoginButton,
            createAccountButton,
          ],
        ),
      ),
    );
  }
}
