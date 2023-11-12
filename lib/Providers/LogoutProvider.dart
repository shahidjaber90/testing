import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';

class LogOutProvider with ChangeNotifier {
  bool isLoading = false;

  Future<void> logoutFunction(
    context,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('getaccesToken').toString();

    isLoading = true;
    notifyListeners();
    final url = Uri.parse('https://cv.glamouride.org/api/logout');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.post(url, headers: headers);
      final result = jsonDecode(response.body);
      String message = result['message'];

      print(message);
      if (response.statusCode == 200) {
        print('logout successfully');
        print(message);
        isLoading = false;
        notifyListeners();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LogInView()));
      } else {
        isLoading = false;
        notifyListeners();
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: TextStyle(
                color: ColorConstant.buttonColor2,
                fontSize: 15,
                letterSpacing: 0.5),
          ),
          backgroundColor: ColorConstant.greyColor,
        ),
      );
    }
  }

  //
}
