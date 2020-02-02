import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Elementt> getRoom(String userEmail, String roomId) async {
  Elementt theRoom = new Elementt.empty();
  String lampID, airConditionerID, shutterID;

  var result, convert, elementType, elementName, index, elementId;
  String url =
      'https://smart-space-server.herokuapp.com/smartspace/elements/smartSpaceProject/$userEmail?search=type&value=Room';
  result = await http
      .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  convert = json.decode(result.body);

  for (index in convert) {
    //elementType = index['elementType'];
    //elementName = index['name'];
    elementId = index['key']['id'];
    //if (elementType == 'Room' && elementName == roomName) {
    if (elementId == roomId) {
      theRoom.elementID = index['key']['id']; //['elementId'];
      theRoom.elementType = index['elementType']; //'Room'; //
      theRoom.elementName = index['name'];
      theRoom.elementExpired = index['expired'];
      theRoom.date = index['created']; //['creationTimestamp'];
      theRoom.userEmail = index['creator']['email']; //['creatorEmail'];
      theRoom.location = index['latlng']; //['location'];
      theRoom.smartspace = index['creator']['smartspace'];
      theRoom.moreAttributes = index['elementProperties'];
      lampID = theRoom.moreAttributes['lamp'];
      //  theElement?? = await getElement(lampID);
      airConditionerID = theRoom.moreAttributes['air conditioner'];
      shutterID = theRoom.moreAttributes['electric shutter'];
    }
  }

  return theRoom;
}

Future<Elementt> getElement(String userEmail, String theElementID) async {
  Elementt theElement = new Elementt.empty();

  var result, convert, elementID;
  String getElementUrl =
      'https://smart-space-server.herokuapp.com/smartspace/elements/smartSpaceProject/$userEmail/smartSpaceProject/$theElementID';
  result = await http.get(Uri.encodeFull(getElementUrl),
      headers: {"Accept": "application/json"});
  convert = json.decode(result.body);

  elementID = convert['key']['id']; //['elementId'];
  if (elementID == theElementID) {
    theElement.elementID = convert['key']['id'];
    //print(theElement.elementID);
    theElement.elementType = convert['elementType'];
    theElement.elementName = convert['name'];
    //print(theElement.elementName);
    theElement.elementExpired = convert['expired'];
    theElement.date = convert['created'];
    theElement.userEmail = convert['creator']['email'];
    theElement.location = convert['latlng'];
    theElement.smartspace = convert['creator']['smartspace'];
    theElement.moreAttributes = convert['elementProperties'];
  }

  return theElement;
}

class Elementt {
  String elementID;
  String elementType;
  String elementName;
  bool elementExpired;
  String date;
  String userEmail;
  Map<String, Object> location;
  String smartspace;
  Map<String, Object> moreAttributes;

  Elementt({
    @required this.elementID,
    @required this.elementType,
    @required this.elementName,
    @required this.elementExpired,
    @required this.date,
    @required this.userEmail,
    @required this.location,
    @required this.smartspace,
    @required this.moreAttributes,
  });

  Elementt.empty();

  factory Elementt.fromJson(Map<String, dynamic> json) {
    Elementt e = new Elementt.empty();
    e.elementID = json['key']['id'];
    e.elementType = json['elementType'];
    e.elementName = json['name'];
    //print(e.elementName);
    e.elementExpired = json['expired'];
    e.date = json['created'];
    e.userEmail = json['creator']['email'];
    e.location = json['latlng'];
    e.smartspace = json['creator']['smartspace'];
    e.moreAttributes = json['elementProperties'];
    //print(e);
    return e;
  }
}