import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

import 'dart:convert';
import '../nfc.dart';
import 'package:http/http.dart' as http;
import 'package:my_smartspace/objects/Elementt.dart';
import 'package:my_smartspace/objects/User.dart';

import '../main.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

Future<void> NfcCheckIn(
    String userEmail, Elementt theDoor, String nfcUrl) async {
  //String url = "'" + nfcUrl + "'";
  //print("1" + nfcUrl);
  var result = await http.post(Uri.encodeFull(nfcUrl),
      headers: {"Content-type": "application/json"},
      body: json.encode({
        "actionKey": {"id": null, "smartspace": null},
        "element": {"id": theDoor.elementID, "smartspace": "smartSpaceProject"},
        "player": {"smartspace": "smartSpaceProject", "email": userEmail},
        "type": "CheckIn",
        "created": null,
        "properties": null
      }));
}

Future<void> checkIn(String userEmail, Elementt theDoor) async {
  /*String nfcUrl = 'null';
  FlutterNfcReader.read().then((response) {
    print(response.content);
    nfcUrl = "'" + response.content + "'";
    //print(nfcUrl);
  });*/

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
  String _tagData = 'Unknown'; //try NFC
  String nfcUrl; // = 'null';

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
      child: Center(
        child: Text(
          'Welcome ' + '${theUser.userName}',
          style: TextStyle(fontSize: 28.0, color: Colors.lightBlue[900]),
        ),
      ),
    );

    /*FlutterNfcReader.read().then((response) {
      print("1");
      nfcUrl = response.content;
      //nfcUrl.split("'");
      print("2");
      print(nfcUrl);
      print("3");
      print(nfcUrl.substring(7));
    });*/

    var nfcButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          //print('hi');
          await FlutterNfcReader.read().then((response) {
            nfcUrl = response.content;
            print(nfcUrl);
            print("*");
            print(nfcUrl.substring(7));
          });
          /*FlutterNfcReader.read().then((response) {
            print(response.content);
            nfcUrl = "'" + response.content + "'";
          });*/
          //try NFC
          /*String tagData;
          // Platform messages may fail, so we use a try/catch PlatformException.
          try {
            _tagData = await Nfc.readTag;
          } on PlatformException  {
            _tagData = 'Failed to read NFC tag';
          }
          //_tagData = await Nfc.readTag;
          print(_tagData);*/
          theUser.isCheckin = true;
          await NfcCheckIn(theUser.userEmail, theDoor, nfcUrl.substring(7));
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
        child: Text('NFC', style: TextStyle(color: Colors.white)),
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
            nfcButton,
          ],
        ),
      ),
    );
  }
}
