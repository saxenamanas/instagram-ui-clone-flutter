import 'package:flutter/material.dart';
import 'package:Insta/pages/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Insta/pages/dashboard.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  FirebaseAuth auth = FirebaseAuth.instance;
  dynamic user;
  void initState() {
    super.initState();
    checkStatus().then((ele) {
      if (ele != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<Usser>(context);
    // final user=getuid();
    return Loader();
    //return user == null ? Welcome() : Loader();
  }

  Future checkStatus() async {
    return auth.currentUser.uid;
  }
}
