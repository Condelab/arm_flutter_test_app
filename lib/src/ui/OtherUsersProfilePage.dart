
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/models/route_argument.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:arm_flutter_test_app/helpers/baseState.dart';

import '../../main.dart';

class OtherUsersProfilePageWidget extends StatefulWidget {
  final RouteArgument routeArgument;
  DocumentSnapshot user;

  OtherUsersProfilePageWidget({Key key, @required this.routeArgument}) {
    user = this.routeArgument.argumentsList[0] as DocumentSnapshot;
  }

  @override
  OtherUsersProfilePageWidgetState createState() => OtherUsersProfilePageWidgetState(user);
}

class OtherUsersProfilePageWidgetState extends BaseState<OtherUsersProfilePageWidget> {
  final DocumentSnapshot user;

  OtherUsersProfilePageWidgetState(this.user);

  bool _status = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                            displayCircleImage(user.data()["profilePictureURL"], 125, false),
                          ],
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
                                    hintText: _status ? user.data()["lastName"]+" "+user.data()["firstName"] : "Enter your full name",
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
                                      hintText: _status ? user.data()["email"] : "Enter Email ID"),
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
                                      hintText: _status ? user.data()["phoneNumber"] : "Enter Mobile Number"),
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



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar(context, user.data()["firstName"]+"'s Profile", true, MyAppState.currentUser),
      body: SingleChildScrollView(
          child: profileCard()),
    );
  }

  @override
  void castStatefulWidget() {
    widget is OtherUsersProfilePageWidget ;
  }
}
