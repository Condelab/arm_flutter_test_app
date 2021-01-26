import 'dart:async';

import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isPassword;
  final String title;
  Color labelColor;

  TextFieldWidget({this.isPassword = false, @required this.title, this.labelColor});
  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState(this.isPassword, this.title, this.labelColor);
}

class _TextFieldWidgetState extends State<TextFieldWidget>  {
  final bool isPassword;
  final String title;
  Color labelColor = Colors.white;

  _TextFieldWidgetState(this.isPassword, this.title, [this.labelColor]);

  @override
  Widget build(BuildContext context) {
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
          TextField(
            style: TextStyle(color: Colors.grey),
            obscureText: isPassword,
            decoration: InputDecoration(
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
                    color: Colors.red, fontWeight: FontWeight.bold)*/),
          ),
        ],
      ),
    );
  }

    }