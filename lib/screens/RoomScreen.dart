import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:my_smartspace/objects/User.dart';
import 'dart:convert';
import '../objects/Elementt.dart';

const actionUrl = 'https://smart-space-server.herokuapp.com/smartspace/actions';

class RoomScreen extends StatefulWidget {
  @override
  User theUser;
  Elementt theRoom;
  RoomScreen(User theUser, Elementt theRoom) {
    this.theUser = theUser;
    this.theRoom = theRoom;
  }
  _RoomScreenState createState() => _RoomScreenState(theUser, theRoom);
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  User theUser;
  Elementt theRoom;
  Elementt _theLamp, _theShutter, _theAirConditioner;
  List dataListElements = List();

  bool lampSwitchVal = false;
  bool shutterSwitchVal = false;
  bool airConditionerSwitchVal = false;

  int airConditionerTemperatureVal = 24;

  Future<void> riseUpTemperature() async {
    setState(() {
      if (airConditionerTemperatureVal != 32) airConditionerTemperatureVal++;
      _theAirConditioner.moreAttributes['temperature'] =
          airConditionerTemperatureVal;
      airConditionerTemp(_theAirConditioner);
    });
  }

  Future<void> riseDownTemperature() async {
    setState(() {
      if (airConditionerTemperatureVal != 16) airConditionerTemperatureVal--;
      _theAirConditioner.moreAttributes['temperature'] =
          airConditionerTemperatureVal;
      airConditionerTemp(_theAirConditioner);
    });
  }

  _RoomScreenState(User theUser, Elementt theRoom) {
    this.theUser = theUser;
    this.theRoom = theRoom;
  }

  Future<void> airConditionerTemp(Elementt theAirConditioner) async {
    var result = await http.post(Uri.encodeFull(actionUrl),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "actionKey": {"id": null, "smartspace": null},
          "element": {
            "id": theAirConditioner.elementID,
            "smartspace": "smartSpaceProject"
          },
          "player": {
            "smartspace": "smartSpaceProject",
            "email": theUser.userEmail
          },
          "type": "ChangeTemperature",
          "created": null,
          "properties": {
            "temperature": theAirConditioner.moreAttributes['temperature'],
            "state": theAirConditioner.moreAttributes['state'],
          }
        }));
  }

  Future<void> elementOnOff(Elementt theElement) async {
    var result = await http.post(Uri.encodeFull(actionUrl),
        headers: {"Content-type": "application/json"},
        body: json.encode({
          "actionKey": {"id": null, "smartspace": null},
          "element": {
            "id": theElement.elementID,
            "smartspace": "smartSpaceProject"
          },
          "player": {
            "smartspace": "smartSpaceProject",
            "email": theUser.userEmail
          },
          "type": "OnOff",
          "created": null,
          "properties": {"state": theElement.moreAttributes['state']}
        }));
  }

  Future<List<Elementt>> getRoomElements(String userEmail) async {
    List<Elementt> allElements = new List<Elementt>();

    //get the elements
    _theLamp =
        await getElement(theUser.userEmail, theRoom.moreAttributes['lamp']);

    _theShutter = await getElement(
        theUser.userEmail, theRoom.moreAttributes['electric shutter']);

    _theAirConditioner = await getElement(
        theUser.userEmail, theRoom.moreAttributes['air conditioner']);

    //add the elements to the list
    allElements.add(_theLamp);
    allElements.add(_theShutter);
    allElements.add(_theAirConditioner);

    //check the state of the elements and set the switch val according to the state
    if (_theLamp.moreAttributes['state'] == 'On') {
      lampSwitchVal = true;
    } else {
      lampSwitchVal = false;
    }

    if (_theShutter.moreAttributes['state'] == 'On') {
      shutterSwitchVal = true;
    } else {
      shutterSwitchVal = false;
    }

    if (_theAirConditioner.moreAttributes['state'] == 'On') {
      airConditionerSwitchVal = true;
      airConditionerTemperatureVal =
          int.parse(_theAirConditioner.moreAttributes['temperature']);
      print(airConditionerTemperatureVal);
    } else {
      airConditionerSwitchVal = false;
      airConditionerTemperatureVal = 24;
    }

    setState(() {
      dataListElements = allElements;
    });

    return allElements;
  }

  @override
  void initState() {
    super.initState();
    this.getRoomElements(theUser.userEmail);
  }

  Widget build(BuildContext context) {
    var roomLabel = Padding(
      padding: EdgeInsets.only(top: 5, left: 5.0, right: 5.0),
      child: Text(
        theRoom.elementName,
        style: TextStyle(
          color: Colors.lightBlue[900],
          fontSize: 20.0,
        ),
      ),
    );

    var lampSwitch = new Switch(
      value: lampSwitchVal,
      onChanged: (newVal) async {
        /*_theLamp =
            await getElement(theUser.userEmail, theRoom.moreAttributes['lamp']);*/
        //onSwitchValueChanged(newVal, _theLamp);
        setState(() {
          lampSwitchVal = newVal;
          elementOnOff(_theLamp);
        });
      },
    );
    var lampOption = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline,
            color: Colors.lightBlue[900],
            size: 35.0,
          ),
          lampSwitch,
        ],
      ),
    );

    var shutterSwitch = new Switch(
      value: shutterSwitchVal,
      onChanged: (newVal) async {
        /*_theShutter = await getElement(
            theUser.userEmail, theRoom.moreAttributes['electric shutter']);*/
        //onSwitchValueChanged(newVal, _theShutter);
        setState(() {
          shutterSwitchVal = newVal;
          elementOnOff(_theShutter);
        });
      },
    );
    var shutterOption = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.panorama,
            color: Colors.lightBlue[900],
            size: 35.0,
          ),
          shutterSwitch,
        ],
      ),
    );

    var airConditionerTempField = Container(
      child: new Center(
        child: new Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new FloatingActionButton(
              heroTag: 'riseUpButton',
              onPressed: () async {
                riseUpTemperature();
              },
              child: new Icon(
                Icons.keyboard_arrow_up, //Icons.add,
                color: Colors.white,
              ),
              backgroundColor: Colors.lightBlue[900],
              mini: true,
            ),
            //if (_theAirConditioner.moreAttributes['temperature'] == null)
            new Text('$airConditionerTemperatureVal',
                //new Text('${_theAirConditioner.moreAttributes['temperature']}',
                style: new TextStyle(fontSize: 25.0)),
            new FloatingActionButton(
              heroTag: 'riseDownButton',
              onPressed: () async {
                riseDownTemperature();
              },
              child: new Icon(
                Icons
                    .keyboard_arrow_down, //const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                color: Colors.white,
              ),
              backgroundColor: Colors.lightBlue[900],
              mini: true,
            ),
            //airConditioner.moreAttributes['state'] = $airConditionerTempValue,
          ],
        ),
      ),
    );
    var airConditionerSwitch = new Switch(
      value: airConditionerSwitchVal,
      onChanged: (newVal) async {
        setState(() {
          airConditionerSwitchVal = newVal;
          elementOnOff(_theAirConditioner);
        });
      },
    );
    var airConditionerOption = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.ac_unit,
            color: Colors.lightBlue[900],
            size: 35.0,
          ),
          airConditionerSwitch,
          if (airConditionerSwitchVal == true) airConditionerTempField,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(28.0),
          children: <Widget>[
            roomLabel,
            lampOption,
            shutterOption,
            airConditionerOption,
          ],
        ),
      ),
    );
  }
}
