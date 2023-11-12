import 'package:flutter/material.dart';

class PaymentProvider with ChangeNotifier {
  bool isCheck = false;
  int currentIndex = 0;
  String paymentCard = '';

  void isChecked(value) {
    isCheck = value;
    notifyListeners();
  }

  void chooseIndex(index) {
    currentIndex = index;
    notifyListeners();
  }

  void paymentWith(values) {
    paymentCard = values;
    notifyListeners();
  }
}
