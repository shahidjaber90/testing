import 'package:flutter/material.dart';

class ResetPasswordProvider with ChangeNotifier {
  bool isObscure = true;
  bool isObscure2 = true;
  Color selectedColor = Colors.transparent;
  List<Color> colors = [
    const Color(0XFFFFFFFF),
    const Color(0XFF000000),
    const Color.fromARGB(255, 251, 8, 8),
    const Color(0XFF8B0000),
    const Color.fromARGB(255, 127, 208, 95),
    const Color.fromARGB(255, 34, 147, 178),
    const Color(0XFFCD5C5C),
    const Color(0XFFDC143C),
    const Color(0XFFFF6347),
    const Color.fromARGB(255, 152, 72, 72),
    const Color.fromARGB(255, 203, 42, 176),
    const Color(0XFFE9967A),
    const Color(0XFFFFE4E1),
    const Color.fromARGB(255, 15, 75, 160),
    const Color.fromARGB(255, 180, 180, 180),
    const Color.fromARGB(255, 128, 124, 0),
    const Color(0XFF00008B),
    const Color.fromARGB(255, 134, 134, 193),
    const Color(0XFF4169E1),
    const Color(0XFF87CEFA),
    const Color(0XFFADD8E6),
    const Color(0XFF00BFFF),
    const Color(0XFF6495ED),
    const Color(0XFF89CFF0),
  ];
 

  void isObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void isObscureText2() {
    isObscure2 = !isObscure2;
    notifyListeners();
  }

  void colorsChange(Color mycolor) {
    selectedColor = mycolor;
    notifyListeners();
  }
}
