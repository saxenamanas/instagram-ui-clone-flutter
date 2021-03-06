import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Insta/models/user.dart';
import 'package:Insta/pages/loader.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> with SingleTickerProviderStateMixin {
  TabController _tabController;
  String friendCode = '';
  FirebaseFirestore db = FirebaseFirestore.instance;
  InstaUser user;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getUserData() async {
    DocumentSnapshot data =
        await db.collection('users').doc(auth.currentUser.uid).get();
    dynamic res = data.data();
    friendCode = data.id;
    setState(() {
      user = InstaUser.sec(res['avatar'], res['bio'], res['username'],
          res['posts'], res['followers'], res['following']);
      // print(user.getUsername + user.getBio + user.getAvatar);
    });
  }

  @override
  void initState() {
    getUserData();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget nameAndBio() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Wrap(
        direction: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              user.getUsername,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(user.getBio),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 10),
            child: Text(
              'Friend Code : ' + friendCode,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    if (user == null)
      return Loader();
    else
      return Scaffold(
        appBar: AppBar(
          title: Text(
            user.getUsername,
            style: TextStyle(fontSize: 17),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                getUserData();
              },
              icon: Icon(Icons.refresh),
            ),
            IconButton(
              onPressed: () async {
                await auth.signOut();
                Navigator.of(context).pushNamed('/login');
              },
              icon: Icon(Icons.power_settings_new),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.getAvatar),
                      radius: 40,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            user.getPosts.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Text('Posts')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            user.getFollowers.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Text('Followers')
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            user.getFollowing.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                        Text('Following')
                      ],
                    ),
                  ],
                ),
                nameAndBio(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/editprofile');
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey[700])),
                        child: Center(child: Text('Edit Profile')),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.grid_on),
                    ),
                    Tab(
                      icon: Icon(Icons.person_pin),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
  }
}
