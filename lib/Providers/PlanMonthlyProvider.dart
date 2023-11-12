import 'package:flutter/material.dart';

class PlanMonthlyProvider with ChangeNotifier {
  bool isCheck = false;
  int currentIndex = 0;

  void isChecked(value) {
    isCheck = value;
    notifyListeners();
  }

  void chooseIndex(index) {
    currentIndex = index;
    notifyListeners();
  }
}
