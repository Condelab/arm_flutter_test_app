import 'package:arm_flutter_test_app/src/Widget/uiAssist/UIhelpers.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/src/Widget/uiAssist/button.dart';
import 'package:arm_flutter_test_app/src/ui/loginPage.dart';
import 'package:arm_flutter_test_app/src/ui/signup.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:arm_flutter_test_app/utils/uidata.dart';
import 'package:local_auth/local_auth.dart';

class WelcomePageWidget extends StatefulWidget {
  WelcomePageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageWidgetState createState() => _WelcomePageWidgetState();
}

class _WelcomePageWidgetState extends BaseState<WelcomePageWidget> {

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }


  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, UIData.routeLogin);
      },
      child: ButtonWidget(buttonText: "Login"),
    );
  }

  Widget _signUpButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, UIData.routeSignup);
      },
      child: ButtonWidget(buttonText: "Signup"),
    );
  }

Widget _alertWidget() {
  return Column(
    children: <Widget>[
      Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('This is to show you I can handle biometrics well with any app.'),
            Text('Click all the buttons and close dialog, then reopen dialog to see result.', style: TextStyle(color: Colors.red),),
            SizedBox(
              height: 30,
            ),
            Text('Biometrics Available: $_canCheckBiometrics\n'),
            RaisedButton(
              child: const Text('Check'),
              onPressed: _checkBiometrics,
            ),
            Text('List Aval. Biometrics: $_availableBiometrics\n'),
            RaisedButton(
              child: const Text('Get List'),
              onPressed: _getAvailableBiometrics,
            ),
            Text('Is this App Authorised to you this device biometrics: $_authorized\n'),
            RaisedButton(
              child: Text(_isAuthenticating ? 'Cancel' : 'Check'),
              onPressed:
              _isAuthenticating ? _cancelAuthentication : _authenticate,
            )
          ])
    ],
  );
}


Widget _label() {
    return Container(
        margin: EdgeInsets.only(top: 40, bottom: 20),
        child: Column(
          children: <Widget>[
            Text(
              'Quick login with Touch ID',
              style: TextStyle(color: Colors.white, fontSize: UIData.textSize),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                showAlertDialogWithCustomWidget(context, "Biometric  Test", "Done", _alertWidget(), true);
              },
              child: Icon(Icons.fingerprint, size: 70, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
        InkWell(
          onTap: () {
            showAlertDialogWithCustomWidget(context, "Enter your PIN", "Submit", _alertWidget(), false);
          },
          child: Text(
           'Touch ID',
              style: TextStyle(
                color: Colors.white,
                fontSize: UIData.textSize,
                decoration: TextDecoration.underline,
              ),
            )),
          ],
        ));
  }

  Widget _title() {
    return Image.asset('assets/images/logo_arm.png');
  }

  hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [config.ArmColors().mainColor(1), config.ArmColors().secondColor(1)])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(),
                SizedBox(
                  height: 80,
                ),
                _submitButton(),
                SizedBox(
                  height: 20,
                ),
                _signUpButton(),
                SizedBox(
                  height: 20,
                ),
                _label()
              ],
            ),
          ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is WelcomePageWidget;
  }
}
