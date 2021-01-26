import 'dart:async';

import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';

class ButtonWidget extends StatefulWidget {
  final String buttonText;
  Color buttonColor;

  ButtonWidget({@required this.buttonText, this.buttonColor});
  @override
  _ButtonWidgetState createState() => _ButtonWidgetState(this.buttonText, this.buttonColor);
}

class _ButtonWidgetState extends State<ButtonWidget>  {
  final String buttonText;
  Color buttonColor = config.ArmColors().secondColor(1);

  _ButtonWidgetState(this.buttonText, [this.buttonColor]);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: buttonColor == null ? config.ArmColors().secondColor(1) : buttonColor ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: UIData.textSize, color: Colors.white),
        ),
      );
  }

    }