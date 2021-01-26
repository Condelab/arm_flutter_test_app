
import 'package:arm_flutter_test_app/helpers/auth/shared_preferences_class.dart';
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/models/route_argument.dart';
import 'package:arm_flutter_test_app/services/Authenticate.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/ui/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';


/// Show error messages
showAppBar(context, String title, bool useHomeIcon, User user) {
  return new AppBar(
    backgroundColor: config.ArmColors().mainColor(1),
    //automaticallyImplyLeading: true
    elevation: 0.0, // for elevation
    titleSpacing: 0.0, // if you want remove title spacing with back button
    leading: new Material( //Custom leading icon, such as back icon or other icon
      color: Colors.transparent,
      child: new InkWell(
          onTap: () {
            if (!useHomeIcon) {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "Logout?",
                desc: "Are you sure you want to proceed?",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () async {
                      user.active = false;
                      user.lastOnlineTimestamp = Timestamp.now();
                      FireStoreUtils.updateCurrentUser(user);
                      await auth.FirebaseAuth.instance.signOut();
                      MyAppState.currentUser = null;
                      SharedPreferencesClass().setLoginChecker(false);
                      Navigator.pushNamedAndRemoveUntil(context, UIData.routeLogin, (Route<dynamic> route) => false);
                    },
                    color: Color.fromRGBO(0, 179, 134, 1.0),
                  ),
                  DialogButton(
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: Colors.red,
                  )
                ],
              ).show();
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePageWidget(user: user)));
            }
          },
          child: new Container(
              padding: const EdgeInsets.fromLTRB(12.0, 16.0, 16.0, 16.0),
              child: Icon(useHomeIcon ? Icons.home_outlined : Icons.logout, color: Colors.black,))
      ),
    ),
    actions: <Widget>[
      Container(
        child: Text(title, style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        margin: EdgeInsets.only(top: 20, right: 7),
      )
    ],
  );
}


/// show AlertDialog
void showAlertDialogWithCustomWidget(BuildContext context, String title, String buttonText, Widget widget, bool showButton) {
  Alert(
      context: context,
      title: title,
      content: widget,
      buttons: showButton ? [
        DialogButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ] : []).show();
}

/// show AlertDialog ok
void showAlertDialogOk(BuildContext context, String title, String desc, String buttonText, AlertType alertType) {
  Alert(
      context: context,
      title: title,
      desc: desc,
      type: alertType,
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
}



Widget appTitle() {
  return Image.asset('assets/images/logo_arm.png');
}

InputDecoration inputDecoration(String title) {
  return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      fillColor: Colors.white,
      filled: true,
      hintText: title,
      hintStyle: TextStyle(color: Colors.grey)
    /*errorText: "Ooops, something is not right!",
                errorStyle: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)*/);
}

Widget textFormFieldWidget(String title, TextFormField textFormField, [Colors labelColor]) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: UIData.textSize, color: labelColor == null ? Colors.white : labelColor),
            )),
        SizedBox(
          height: 3,
        ),
        textFormField,
      ],
    ),
  );
}


Widget appBackButton(context) {
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
            child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
          ),
          Text('Back',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))
        ],
      ),
    ),
  );
}


