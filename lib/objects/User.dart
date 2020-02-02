import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User {
  String userName;
  String userEmail;
  String userAvatar;
  String userRole;
  bool isCheckin;

  User(
      {@required this.userName,
      @required this.userEmail,
      @required this.userAvatar,
      @required this.userRole,
      isCheckin = false});

  User.empty();
}