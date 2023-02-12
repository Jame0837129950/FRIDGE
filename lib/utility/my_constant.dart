import 'package:flutter/material.dart';

class MyConstant {

  static int hour = 14;
  static int mimus = 44;
  static Color dark = const Color.fromARGB(255, 21, 1, 135);
static Color active = Colors.pink;

  TextStyle h1Style({Color? color}) => TextStyle(
        fontSize: 36,
        color: color ?? dark,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style({Color? color}) => TextStyle(
        fontSize: 20,
        color: color ?? dark,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style({Color? color}) => TextStyle(
        fontSize: 14,
        color: color ?? dark,
        fontWeight: FontWeight.normal,
      );
}
