import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:uuid/uuid.dart';
import 'auth/shared_preferences_class.dart';
import 'empty_widget/empty_widget.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;

abstract class BaseState<T extends StatefulWidget> extends State {

  String url, returned_json, address, latitude, longitude;
  Response response;

  void castStatefulWidget();

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  /// the internet connectivity status
  bool isOnline = true;
  SharedPreferencesClass sharedPreferencesClass = SharedPreferencesClass();
  bool isLogedin = false;
  bool isFirstLogedin = false;
  String token;
  var uuid = Uuid();
  var logger = Logger();



  @override
  initState() {
    _isLogedinCheck();
    _initConnectivity();
    _checkFirstSeen();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await _updateConnectionStatus().then((bool isConnected) => setState(() {
        isOnline = isConnected;
      }));
      });
    super.initState();
  }

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstLogedin = (prefs.getBool('seen') ?? false);
    if (isFirstLogedin) {
      setState(() {
        isFirstLogedin = isFirstLogedin;
      });
    } else {
      prefs.setBool('seen', true);
      isFirstLogedin = isFirstLogedin;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    await _updateConnectionStatus().then((bool isConnected) => setState(() {
      isOnline = isConnected;
    }));
  }


  Future<bool> _updateConnectionStatus() async {
    bool isConnected;
    try {
      final List<InternetAddress> result =
      await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
      return false;
    }
    if (!isConnected) {
      showToast(UIData.txtNoNetwork);
    }
    return isConnected;
  }

  _isLogedinCheck() {
    sharedPreferencesClass.getLoginChecker().then((bool answer) {
      //print("isLogedinCheck::::::::::::::::: " + answer.toString());
      setState(() {
        isLogedin = answer;
        if (isLogedin){
          //getLoginData();
        }
      });
    });
  }

   imageNameGenerator() {
    return uuid.v4();
   }

  getLocation() async {
    LocationPermission permission = await requestPermission();

    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');


    final coordinates = new Coordinates(position.latitude, position.longitude);
    debugPrint('coordinates is: $coordinates');

    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    /*// print number of retured addresses
    debugPrint('${addresses.length}');
    // print the best address
    debugPrint("${first.featureName} : ${first.addressLine}");
    //print other address names
    debugPrint("Country:${first.countryName} AdminArea:${first.adminArea} SubAdminArea:${first.subAdminArea}");
    //print more address names
    debugPrint("Locality:${first.locality}: Sublocality:${first.subLocality}");*/
    setState(() {
      address = "${first.addressLine}.";
      longitude = '${position.longitude}';
      latitude = '${position.latitude}';
    });
    logger.v("Google Address Response: "+address);
  }


  Widget NoConnectionWidget() {
    return Center(
        child: Container(
          height: 500,
          width:350,
          child:  EmptyListWidget(
              image : "assets/images/im_emptyIcon_3.png",
              //packageImage: "PackageImage.Image_4",
              title: 'Ughr!!',
              subTitle: 'Check your connection',
              titleTextStyle: Theme.of(context).typography.dense.headline4.copyWith(color: Color(0xff9da9c7)),
              subtitleTextStyle: Theme.of(context).typography.dense.bodyText2.copyWith(color: Color(0xffabb8d6))
          ),
        )
    );
  }

  Widget ConnectionErrorWidget() {
    return Center(
        child: Container(
          height: 500,
          width:350,
          child:  EmptyListWidget(
              image : null,
              packageImage: PackageImage.Image_1,
              title: 'Opps!',
              subTitle: 'We couldn\'t get a thing',
              titleTextStyle: Theme.of(context).typography.dense.headline4.copyWith(color: Color(0xff9da9c7)),
              subtitleTextStyle: Theme.of(context).typography.dense.bodyText2.copyWith(color: Color(0xffabb8d6))
          ),
        )
    );
  }

  Widget EmptyContentWidget() {
    return Center(
        child: Container(
          height: 500,
          width:350,
          child:  EmptyListWidget(
              image : null,
              packageImage: PackageImage.Image_3,
              title: 'Not Found',
              subTitle: 'We couldn\'t find one',
              titleTextStyle: Theme.of(context).typography.dense.headline4.copyWith(color: Color(0xff9da9c7)),
              subtitleTextStyle: Theme.of(context).typography.dense.bodyText2.copyWith(color: Color(0xffabb8d6))
          ),
        )
    );
  }

  void showToast(String message) {
    //isConnected = false;//remains false
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

}