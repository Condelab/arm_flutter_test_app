import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/models/route_argument.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/ui/ChatScreen.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:fluttertoast/fluttertoast.dart';

import '../../main.dart';

class ChatListViewItem extends StatelessWidget {
  final String image;
  final String name;
  final DocumentSnapshot userInfo;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final String onlinOffline;
  const ChatListViewItem({
    Key key,
    this.image,
    this.name,
    this.userInfo,
    this.lastMessage,
    this.time,
    this.isOnline,
    this.onlinOffline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppState.currentUser.userID != userInfo.data()["id"] ? Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: displayCircleImage(image, 50, false),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                      isOnline
                          ? Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              height: 18,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25.0),
                                  )),
                              child: Center(
                                  child: Text(
                                    onlinOffline,
                                style: TextStyle(fontSize: 11, color: Colors.white),
                              )),
                            )
                          : SizedBox()
                    ],
                  ),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: "<<< Slide left <<< to show available options",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                ),
              ),
            ],
          ),
          Divider(
            endIndent: 12.0,
            indent: 12.0,
            height: 0,
          ),
        ],
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Profile',
          color: config.ArmColors().mainColor(1),
          icon: Icons.person_rounded,
          onTap: () {
            Navigator.pushNamed(
                      context,
                      UIData.routeOtherUsersProfile,
                arguments: {'routeArgument': new RouteArgument(argumentsList: [userInfo])}
                    );
          },
        ),
        IconSlideAction(
          caption: 'Chat',
          color: config.ArmColors().accentColor(1),
          icon: Icons.chat_outlined,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen(name: userInfo.data()['firstName'], photoUrl: userInfo.data()['profilePictureURL'], receiverUid: userInfo.data()['id'],)));
          },
        ),
      ],
    )
    : Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: ListTile(
                title: Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                subtitle: Text(
                  lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
                leading: displayCircleImage(image, 50, false),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      time,
                      style: TextStyle(fontSize: 12),
                    ),
                    isOnline
                        ? Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      height: 18,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          )),
                      child: Center(
                          child: Text(
                            onlinOffline,
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          )),
                    )
                        : SizedBox()
                  ],
                ),
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Errmm!!! on planet earth we cant chat ourself! ;)",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),
            ),
          ],
        ),
        Divider(
          endIndent: 12.0,
          indent: 12.0,
          height: 0,
        ),
      ],
    );
  }
}
