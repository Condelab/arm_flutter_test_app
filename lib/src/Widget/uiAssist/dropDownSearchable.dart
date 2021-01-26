import 'dart:async';

import 'package:arm_flutter_test_app/config/app_config.dart' as config;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:arm_flutter_test_app/utils/uidata.dart';

class DropDownSearchableWidget extends StatefulWidget {
  final String title;
  Color labelColor;

  DropDownSearchableWidget({@required this.title, this.labelColor});
  @override
  _DropDownSearchableWidgetState createState() => _DropDownSearchableWidgetState(this.title, this.labelColor);
}

class _DropDownSearchableWidgetState extends State<DropDownSearchableWidget>  {
  final String title;
  Color labelColor = Colors.white;

  _DropDownSearchableWidgetState(this.title, [this.labelColor]);

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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: UIData.textSize,
                    color: labelColor == null ? Colors.white : labelColor),
              )),
          SizedBox(
            height: 3,
          ),
          DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              showSelectedItem: true,
              items: [
                "Select an option",
                "Option 1",
                "Option 2",
                "Option 3",
                "Option 4",
                "Option 5",
                "Option 6",
                "Option 7",
              ],
              popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: print,
              dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
                  helperStyle: TextStyle(color: Colors.grey),
                  labelStyle: TextStyle(
                      color: Colors.grey,
                      backgroundColor: Colors.transparent),
                  hintStyle: TextStyle(color: Colors.grey)),
              selectedItem: "Brazil"),
        ],
      ),
    );
  }

    }