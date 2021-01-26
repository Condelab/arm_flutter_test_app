import 'dart:async';

import 'package:arm_flutter_test_app/helpers/constants.dart';
import 'package:arm_flutter_test_app/models/User.dart';
import 'package:arm_flutter_test_app/services/Authenticate.dart';
import 'package:arm_flutter_test_app/services/helper.dart';
import 'package:arm_flutter_test_app/src/ui/homePage.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/src/ui/onboarding.dart';
import 'package:arm_flutter_test_app/src/ui/welcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:arm_flutter_test_app/config/app_config.dart' as config;

import '../main.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => new _SplashWidgetState();
}

class _SplashWidgetState extends BaseState<SplashWidget>{
  bool _seen = false;
  bool _isLogedin = false;

  Future<bool> _isLogedinCheck() async {
    sharedPreferencesClass.getLoginChecker().then((bool answer) {
      setState(() {
        _isLogedin = false;
      });
    });
    return _isLogedin;
  }

  Future checkFirstSeen() async {
    sharedPreferencesClass.getTourGuideChecker().then((bool value) {
      _seen = value;
    });
  }

  Widget whereDoIGoFromHere(BuildContext context) {
    //check user is logged in
    if (isLogedin) {


      auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser;
      return FutureBuilder<User>(
          future: FireStoreUtils().getCurrentUser(firebaseUser.uid),
          builder: (BuildContext context, AsyncSnapshot<User> user){
            if (user.hasData) {
              MyAppState.currentUser = user.data;
              //update online
              print("ZZZZZstarted");
              //tokenStream.resume();
              MyAppState.currentUser.active = true;
              FireStoreUtils.updateCurrentUser(MyAppState.currentUser);
              //
              return HomePageWidget(user: user.data);
            } else if (user.connectionState == ConnectionState.waiting) {
              return Scaffold(
                backgroundColor: config.ArmColors().mainColor(1),
                body: Center(
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
              );
            } else {
              return WelcomePageWidget();
            }}
      );
    } else {
      if (_seen) {
        return WelcomePageWidget();
      } else {
        return OnBoardingWidget();
      }
    }

  }

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    _isLogedinCheck();
    checkFirstSeen();
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context)  {
    return SplashScreen.navigate(
      name: 'assets/flare/minion.flr',
      //next: (context) => new BuilderPage(), //OnBoardingWidget(),
      next: (context) => whereDoIGoFromHere(context), //OnBoardingWidget(),
      until: () => Future.delayed(Duration(seconds: 3)),
      backgroundColor: Colors.white,
      startAnimation: 'Stand',
    );
  }

  @override
  void castStatefulWidget() {
    widget is SplashWidget;
  }
}
