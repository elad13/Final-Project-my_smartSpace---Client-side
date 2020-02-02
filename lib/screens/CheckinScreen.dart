import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_smartspace/objects/Elementt.dart';
import 'package:my_smartspace/objects/User.dart';

import '../main.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

Future<void> checkIn(String userEmail, Elementt theDoor) async {
  String url = //'https://smartspace.cfapps.io/smartspace/actions';
      'https://smart-space-server.herokuapp.com/smartspace/actions';
  var result = await http.post(Uri.encodeFull(url),
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "actionKey": {"id": null, "smartspace": null},
        "element": {"id": theDoor.elementID, "smartspace": "smartSpaceProject"},
        "player": {
          "smartspace": "smartSpaceProject",
          "email": userEmail //'${theUser.userEmail}' //"eladm1991@gmail.com"
        },
        "type": "CheckIn",
        "created": null,
        "properties": null
      }));
}

Future<void> checkOut(User theUser, Elementt theDoor) async {
  String url = //'https://smartspace.cfapps.io/smartspace/actions';
      'https://smart-space-server.herokuapp.com/smartspace/actions';
  var result = await http.post(Uri.encodeFull(url),
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "actionKey": {"id": null, "smartspace": null},
        "element": {"id": theDoor.elementID, "smartspace": "smartSpaceProject"},
        "player": {
          "smartspace": "smartSpaceProject",
          "email": theUser.userEmail //"eladm1991@gmail.com"
        },
        "type": "CheckOut",
        "created": null,
        "properties": null
      }));
}

class CheckinScreen extends StatefulWidget {
  @override
  User theUser;
  Elementt theDoor;
  CheckinScreen(User theUser, Elementt theDoor) {
    this.theUser = theUser;
    this.theDoor = theDoor;
  }
  _CheckinScreenState createState() => _CheckinScreenState(theUser, theDoor);
}

class _CheckinScreenState extends State<CheckinScreen> {
  @override
  User theUser;
  Elementt theDoor;
  _CheckinScreenState(User theUser, Elementt theDoor) {
    this.theUser = theUser;
    this.theDoor = theDoor;
  }

  Widget build(BuildContext context) {
        var welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome ' + '${theUser.userName}',
        style: TextStyle(fontSize: 28.0, color: Colors.lightBlue[900]),
      ),
    );

    final checkInButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          //userPressedCheckIn = true;
          theUser.isCheckin = true;
          await checkIn(theUser.userEmail, theDoor);
          print('${theUser.userEmail}');
          //Navigator.of(context).pushNamed(NFCReader.tag);
          //Navigator.of(context).pushNamed(HomeScreen.tag);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(theUser, theDoor)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Check In', style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logoField,
            SizedBox(height: 20.0),
            welcome,
            SizedBox(height: 10.0),
            checkInButton,
          ],
        ),
      ),
    );
  }
}