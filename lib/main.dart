import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;

import 'models/User.dart';
import 'router/router.dart';
import 'services/Authenticate.dart';
import 'utils/uidata.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static User currentUser;
  //StreamSubscription tokenStream;

  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.white,
              child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: config.ArmColors().secondDarkColor(1),
                        size: 25,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Firebase initialization failed, close app and try again!',
                        style: TextStyle(color: config.ArmColors().secondDarkColor(1), fontSize: 25),
                      ),
                    ],
                  )),
            ),
          ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MaterialApp(
      title: 'ARM Holding Co.',
      initialRoute: UIData.routeSplash,
      //initialRoute: UIData.routeLogin,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Color(0xFF252525),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        accentColor: config.ArmColors().mainDarkColor(1),
        hintColor: config.ArmColors().secondDarkColor(1),
        focusColor: config.ArmColors().accentDarkColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Color(0xFF252525)),
          headline5: TextStyle(fontSize: 20.0, color: config.ArmColors().secondDarkColor(1)),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondDarkColor(1)),
          headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondDarkColor(1)),
          headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.ArmColors().secondDarkColor(1)),
          headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.ArmColors().secondDarkColor(1)),
          subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.ArmColors().secondDarkColor(1)),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondDarkColor(1)),
          bodyText2: TextStyle(fontSize: 12.0, color: config.ArmColors().secondDarkColor(1)),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondDarkColor(1)),
          caption: TextStyle(fontSize: 12.0, color: config.ArmColors().secondDarkColor(0.7)),
        ),
      ),
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.white,
        brightness: Brightness.light,
        accentColor: config.ArmColors().mainColor(1),
        focusColor: config.ArmColors().accentColor(1),
        hintColor: config.ArmColors().secondColor(1),
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
          headline5: TextStyle(fontSize: 20.0, color: config.ArmColors().secondColor(1)),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondColor(1)),
          headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondColor(1)),
          headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.ArmColors().secondColor(1)),
          headline1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w300, color: config.ArmColors().secondColor(1)),
          subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: config.ArmColors().secondColor(1)),
          headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondColor(1)),
          bodyText2: TextStyle(fontSize: 12.0, color: config.ArmColors().secondColor(1)),
          bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: config.ArmColors().secondColor(1)),
          caption: TextStyle(fontSize: 12.0, color: config.ArmColors().secondColor(0.6)),
        ),
      ),
    );
  }

  @override
  void initState() {
    initializeFlutterFire();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (auth.FirebaseAuth.instance.currentUser != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //update offline
        print("ZZZZZminimized");
        //tokenStream.pause();
        currentUser.active = false;
        currentUser.lastOnlineTimestamp = Timestamp.now();
        FireStoreUtils.updateCurrentUser(currentUser);
      } else if (state == AppLifecycleState.resumed) {
        //update online
        print("ZZZZZmaximized");
        //tokenStream.resume();
        currentUser.active = true;
        FireStoreUtils.updateCurrentUser(currentUser);
      }
    }
  }
}
