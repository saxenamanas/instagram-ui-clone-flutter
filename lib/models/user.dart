import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InstaUser {
  String uid, avatar, bio, email, username;
  String get getAvatar => avatar;
  String get getEmail => email;
  String get getBio => bio;
  String get getUsername => username;
  InstaUser(avatar, bio, email) {
    this.avatar = avatar;
    this.bio = bio;
    this.email = email;
  }

  InstaUser.sec(avatar, bio, username) {
    this.avatar = avatar;
    this.bio = bio;
    this.username = username;
  }
}