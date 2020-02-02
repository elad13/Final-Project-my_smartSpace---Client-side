import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Actionn {
  String actionID;
  String elementID;
  String email;
  String type;
  String date;
  String smartspace;
  Map<String, Object> moreAttributes;

  Actionn({
    @required this.actionID,
    @required this.elementID,
    @required this.email,
    @required this.type,
    @required this.date,
    @required this.smartspace,
    @required this.moreAttributes,
  });

  Actionn.empty();
}