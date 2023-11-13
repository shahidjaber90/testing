// ignore: file_names
import 'dart:convert';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:colorvelvetus/Screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  bool isObscure = true;
  bool isCheck = false;
  bool isLoading = false;

  void isObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void isChecked(value) {
    isCheck = value;
    notifyListeners();
  }

  Future<void> loginAPIRequest(
    emailController,
    passwordController,
    context,
  ) async {
    isLoading = true;
    notifyListeners();
    String message = '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final response = await http.post(
        Uri.parse('https://cv.glamouride.org/api/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController,
          'password': passwordController,
        }),
      );

      var responseData = jsonDecode(response.body);
      message = responseData['message'];
      print('Hello Shahid $message and ${responseData["access_token"]}');
      if (response.statusCode == 200) {
        var accessToken = responseData['access_token'];
        var sub_message = responseData['sub_message'];
        await prefs.setString('getaccesToken', accessToken);
        await prefs.setString('sub_message', sub_message);  
        await prefs.setString('userEmail', emailController);  
        // ignore: avoid_print
        print(accessToken);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.whiteColor,
            content: Text(
              message,
              style: TextStyle(
                color: ColorConstant.buttonColor2,
              ),
            ),
          ),
        );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
        // ignore: avoid_print
        print(message);
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      // ignore: avoid_print
      print("error is here: >>>> ${e.toString()}");
      // ignore: avoid_print
      print('message:: $message');
    }
  }
}
