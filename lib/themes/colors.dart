import 'package:flutter/material.dart';

Color getGreenColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Color(0xff3A6F73)
      : Color(0xffAED6DC);
}

Color getRedColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Color(0xffC86B60)
      : Color(0xffFF9A8C);
}

Color getGreyColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Color(0xff4A536D);
}

Color getitemColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Color(0xff4A536B)
      : Color(0xff272D3B);
}

Color getTextColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withOpacity(0.5)
      : Color.fromARGB(147, 74, 83, 107);
}

Color getTextColor2(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}
