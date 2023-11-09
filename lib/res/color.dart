import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(181, 163, 101, .1),
  100: const Color.fromRGBO(181, 163, 101, .2),
  200: const Color.fromRGBO(181, 163, 101, .3),
  300: const Color.fromRGBO(181, 163, 101, .4),
  400: const Color.fromRGBO(181, 163, 101, .5),
  500: const Color.fromRGBO(181, 163, 101, .6),
  600: const Color.fromRGBO(181, 163, 101, .7),
  700: const Color.fromRGBO(181, 163, 101, .8),
  800: const Color.fromRGBO(181, 163, 101, .9),
  900: const Color.fromRGBO(181, 163, 101, 1),
};

class AppColors {
  static MaterialColor appColorFull = MaterialColor(0xFFB5A365, color);
  static const Color appColor = Color(0XFFB5A365);
  static const Color blackColor = Color(0XFF373737);
  static const Color whiteColor = Color(0XFFFFFFFF);
  static const Color greyColor = Color(0XFFF5F5F5);
  static const Color lightBlack = Color(0XFF808080);
  static const Color transparent = Colors.transparent;
}