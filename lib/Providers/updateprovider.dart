import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';

class UpdateProvider with ChangeNotifier {
  File? imageFile;
  String imageName = '';
  bool isLoading = false;

  Future<void> updateInfo(phoneController, context) async {
    isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    print(myToken);
    final url = Uri.parse('https://cv.glamouride.org/api/update-profile');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    final body = jsonEncode({
      'phone': phoneController,
    });

    final response = await http.post(url, headers: headers, body: body);

    var result = jsonDecode(response.body);
    String message = result['message'];
    if (response.statusCode == 200) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.buttonColor2,
          content: Text(
            message,
            style: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LogInView(),
          ));

      isLoading = false;
      notifyListeners();

      print('API response: ${response.body}');
    } else {
      isLoading = false;
      notifyListeners();
      // ignore: avoid_print
      print('response data $message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }

  Future<void> updateImage(phoneController, context) async {
    isLoading = true;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final url = Uri.parse('https://cv.glamouride.org/api/update-profile');
    var request = http.MultipartRequest("POST", url);

    request.headers['Authorization'] = 'Bearer $myToken';
    request.fields['phone'] = '03121186020';

    // request.files.add(
    //   http.MultipartFile(
    //     'profile_pic',
    //     imageFile!.readAsBytes().asStream(),
    //     imageFile!.lengthSync(),
    //     filename: imageName,
    //     contentType: MediaType('image', 'jpg'),
    //   ),
    // );

    final response = await request.send();

    var message = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.buttonColor2,
          content: Text(
            message,
            style: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
      Navigator.pop(context);

      isLoading = false;
      notifyListeners();

      print('API response: ${response.stream}');
    } else {
      isLoading = false;
      notifyListeners();
      // ignore: avoid_print
      print('response data $message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }
}
