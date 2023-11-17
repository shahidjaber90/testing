import 'dart:io';

import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResetPasswordProvider with ChangeNotifier {
  bool isLoading = false;
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

  Future<void> uploadNetworkImage2(
      String artID, File imageFile, context) async {
    isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail').toString();
    String myToken = prefs.getString('getaccesToken').toString();
    print('userEmail: $userEmail');
    print('artID: $artID');
    print('artID: $imageFile');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://cv.glamouride.org/api/upload-art'),
      );

      // Add headers, including the access token
      request.headers['Authorization'] = 'Bearer $myToken';

      request.fields['email'] = userEmail;
      request.fields['art_id'] = artID;
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile!.path),
      );

      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        isLoading = false;
        notifyListeners();
        String message = 'Image uploaded successfully';
        // ignore: use_build_context_synchronously
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
      } else {
        isLoading = false;
        notifyListeners();
        print('Failed to upload image. Status code: ${response.statusCode}');
        String message = 'Failed to upload image. Status code';
        // ignore: use_build_context_synchronously
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
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('Error Reasone is:: $e');
    }
  }

  ///////////
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
