import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_smartspace/objects/Elementt.dart';
import 'package:my_smartspace/objects/User.dart';
import '../main.dart';
import 'CheckinScreen.dart';
import 'package:http/http.dart' as http;

import 'HomeScreen.dart';

Future<List<String>> getDoors(String userEmail) async {
  List<String> doorsID = [];

  var result, convert, elementType, index, i = 0;
  String url =
      'https://smart-space-server.herokuapp.com/smartspace/elements/smartSpaceProject/$userEmail?search=type&value=Door';
  result = await http
      .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  convert = json.decode(result.body);
  print(convert);

  for (index in convert) {
    elementType = index['elementType'];
    if (elementType == 'Door') {
      doorsID[i] = index['key']['id'];
      i++;
    }
  }
  print(doorsID);
  return doorsID;
}

class DoorsScreen extends StatefulWidget {
  @override
  User theUser;
  DoorsScreen(User theUser) {
    this.theUser = theUser;
  }
  _DoorsScreenState createState() => _DoorsScreenState(theUser);
}

class _DoorsScreenState extends State<DoorsScreen> {
  @override
  User theUser;
  List<Elementt> _allDoors = [];
  Elementt _currentDoor;
  List<DropdownMenuItem<Elementt>> _dropDownMenuItems;
  List dataList = List();

  _DoorsScreenState(User theUser) {
    this.theUser = theUser;
  }

  Future<List<Elementt>> getAllDoors(String userEmail) async {
    List<Elementt> allDoors = new List<Elementt>(); //[];

    var result, convert, index;

    String url =
        'https://smart-space-server.herokuapp.com/smartspace/elements/smartSpaceProject/$userEmail?search=type&value=Door';
    result = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    convert = json.decode(result.body);
    List<Elementt> doors =
        (convert as List).map((data) => Elementt.fromJson(data)).toList();
    for (index in doors) {
      allDoors.add(index);
    }

    setState(() {
      dataList = allDoors;
    });
    return allDoors;
  }

  @override
  void initState() {
    super.initState();
    this.getAllDoors(theUser.userEmail);
  }

  List<DropdownMenuItem<Elementt>> getDropDownMenuItems() {
    dataList.map((item) {
      return new DropdownMenuItem(value: item, child: new Text(item.elementID));
    }).toList();
  }

  Widget build(BuildContext context) {
    void changedDropDownItem(Elementt selectedDoor) {
      setState(() {
        _currentDoor = selectedDoor;
      });
    }

    var combo = Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Select a door"),
            SizedBox(
              height: 20.0,
            ),
            DropdownButton(
              value: _currentDoor,
              items: dataList.map((item) {
                return new DropdownMenuItem(
                  child: new Text(item.elementID),
                  value: item,
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _currentDoor = newVal;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            //Text('Selected: ${_selectedCompany.name}'),
          ],
        ),
      ),
    );

    final selectDoorButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (_currentDoor.moreAttributes['status'] == 'Open') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(theUser, _currentDoor)),
            );
          } else if (_currentDoor.moreAttributes['status'] == 'Close') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckinScreen(theUser, _currentDoor)),
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlue[900],
        child: Text('Select', style: TextStyle(color: Colors.white)),
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
            combo,
            SizedBox(height: 10.0),
            selectDoorButton,
          ],
        ),
      ),
    );
  }
}
