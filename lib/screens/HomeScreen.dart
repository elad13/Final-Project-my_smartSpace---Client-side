import 'package:flutter/material.dart';

import 'package:my_smartspace/objects/Elementt.dart';
import 'package:my_smartspace/screens/RoomScreen.dart';

import '../objects/User.dart';
import '../main.dart';

import 'CheckinScreen.dart';
import 'DoorsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  User theUser;
  Elementt theDoor;
  HomeScreen(User theUser, Elementt theDoor) {
    this.theUser = theUser;
    this.theDoor = theDoor;
  }
  _HomeScreenState createState() => _HomeScreenState(theUser, theDoor);
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  User theUser;
  Elementt theDoor;
  Elementt theLivingRoom, theBedroom;

  _HomeScreenState(User theUser, Elementt theDoor) {
    this.theUser = theUser;
    this.theDoor = theDoor;
  }

  Widget build(BuildContext context) {
    var livingRoom = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          theLivingRoom = await getRoom(
              theUser.userEmail, theDoor.moreAttributes['living room']);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomScreen(theUser, theLivingRoom)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Living Room', style: TextStyle(color: Colors.white)),
      ),
    );

    var bedroom = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          theBedroom = await getRoom(
              theUser.userEmail, theDoor.moreAttributes['bedroom']);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoomScreen(theUser, theBedroom)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Bedroom', style: TextStyle(color: Colors.white)),
      ),
    );

    var checkOutButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          theUser.isCheckin = false;
          await checkOut(theUser, theDoor);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoorsScreen(theUser)),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Check Out', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logoField,
            SizedBox(height: 20.0),
            livingRoom,
            bedroom,
            checkOutButton,
          ],
        ),
      ),
    );
  }
}
