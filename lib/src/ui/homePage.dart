import 'dart:async';

import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/services/Authenticate.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/Widget/ChatListViewItem.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;

import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../main.dart';


class HomePageWidget extends StatefulWidget {
  final User user;

  HomePageWidget({Key key, @required this.user}) : super(key: key);

  @override
  HomePageWidgetState createState() => HomePageWidgetState(user);
}

class HomePageWidgetState extends BaseState<HomePageWidget> {
  final User user;

  HomePageWidgetState(this.user);

  int selectedIndex = 0;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  Timer timer;
  List<Widget> widgetOptions;
  bool _status = true;
  List<DocumentSnapshot> usersList;
  StreamSubscription<QuerySnapshot> _subscription;

  @override
  void initState() {
    _subscription = firestore.collection("users").snapshots().listen((dataSnapshot) {
      setState(() {
        usersList = dataSnapshot.docs;
      });
      print("Users List ${usersList.length}");
      widgetOptions = [
        usersCard(),
        profileCard(),
      ];
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }


  Widget usersCard() {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: usersList != null ? ListView.builder(
            shrinkWrap: true,
            itemCount: usersList.length,
            itemBuilder: (context, index) {
              return ChatListViewItem(
                userInfo: usersList[index],
                isOnline: usersList[index].data()["active"],
                image: usersList[index].data()["profilePictureURL"],
                lastMessage: usersList[index].data()["lastName"],
                name: usersList[index].data()["firstName"],
                onlinOffline: usersList[index].data()["active"] ? "online" : "offline",
                time: "19:27 PM",
              );
            }) : Center(
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: config.ArmColors().secondColor(1),
          ),
          SizedBox(width: 20),
          Text("Please wait...", style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      )
    ),
        ),
      );
  }
  Widget profileCard() {
      return Center(
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 200.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            displayCircleImage(user.profilePictureURL, 125, false),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: InkWell(
                                onTap: () => showToast("Not supported"),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Parsonal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration: InputDecoration(
                                      hintText: _status ? user.fullName() : "Enter your full name",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email ID',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration:  InputDecoration(
                                        hintText: _status ? user.email : "Enter Email ID"),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextField(
                                    decoration:  InputDecoration(
                                        hintText: _status ? user.phoneNumber : "Enter Mobile Number"),
                                    enabled: !_status,
                                  ),
                                ),
                              ],
                            )),
                        //!_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          ],
        ),
      );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        showToast("Not supported");
        // setState(() {
        //   _status = false;
        // });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar(context, "Dashboard", false, user),
      body: SingleChildScrollView(
      child: widgetOptions != null ? widgetOptions.elementAt(selectedIndex)
      : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Text("Collating users list...", style: TextStyle(color: Colors.black, fontSize: 16)),
                ],
              )
            ],
          )

      )),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded, color: config.ArmColors().secondColor(1)), label: 'Users', tooltip: 'All Users'),
         BottomNavigationBarItem(icon: Icon(Icons.pending_actions_rounded, color: config.ArmColors().secondColor(1)), label: 'Profile', tooltip: 'your Profile'),
          ],
        backgroundColor: config.ArmColors().mainColor(1),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        //fixedColor: Colors.black,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: onItemTapped,
      ),
    );
  }



  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void castStatefulWidget() {
    widget is HomePageWidget;
  }
}