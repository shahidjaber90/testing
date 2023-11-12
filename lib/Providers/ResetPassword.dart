import 'package:flutter/material.dart';

class ResetPasswordProvider with ChangeNotifier {
  bool isObscure = true;
  bool isObscure2 = true;

  void isObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }
  void isObscureText2() {
    isObscure2 = !isObscure2;
    notifyListeners();
  }

}