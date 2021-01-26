import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/helpers/baseState.dart';
import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:arm_flutter_test_app/utils/uidata.dart';

class OnBoardingWidget extends StatefulWidget {
  @override
  _OnBoardingWidgetState createState() => new _OnBoardingWidgetState();
}

class _OnBoardingWidgetState extends BaseState<OnBoardingWidget>{

  final pageList = [
    PageModel(
        color: config.ArmColors().mainColor(1),
        heroImagePath: 'assets/images/hotels.png',
        title: Text('Asset Management',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text('At ARM, we understand your investment goals, and how to make your money work ... insurance companies, trusts, pension funds and government agencies.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'assets/images/key.png'),
    PageModel(
        color: config.ArmColors().secondColor(1),
        heroImagePath: 'assets/images/banks.png',
        title: Text('Pensions',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontSize: 34.0,
            )),
        body: Text(
            'ARM Pension Managers (PFA) Ltd is one of the first seven Pension Fund Administrators (PFA) granted license by the National Pension Commission in December 2005.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            )),
        iconImagePath: 'assets/images/wallet.png'),
    PageModel(
      color: config.ArmColors().mainColor(1),
      heroImagePath: 'assets/images/stores.png',
      title: Text('ARM Life Plc',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 34.0,
          )),
      body: Text('ARM Life Plc a life insurance company with a vision to be a leading provider of protection and wealth creation solutions in Nigeria.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          )),
      icon: Icon(
        Icons.shopping_cart,
        color: config.ArmColors().secondColor(1),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        skipButtonColor: config.ArmColors().secondColor(1),
        doneButtonBackgroundColor: config.ArmColors().secondColor(1),
        pageList: pageList,
        onDoneButtonPressed: () {
          sharedPreferencesClass.setTourGuideChecker(true);
          Navigator.of(context).pushReplacementNamed(UIData.routeWelcome);
        },
        onSkipButtonPressed: () {
          sharedPreferencesClass.setTourGuideChecker(true);
          Navigator.of(context).pushReplacementNamed(UIData.routeWelcome);
        },
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is OnBoardingWidget;
  }

}