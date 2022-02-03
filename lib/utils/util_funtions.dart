import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilFuntions {
  static void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }
}
