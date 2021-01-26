import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'color_loader_3.dart';


class DefaultLoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ColorLoader3(
      radius: 20.0,
      dotRadius: 5.0,
    ));
  }
}
