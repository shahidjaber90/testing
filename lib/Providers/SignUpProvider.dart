import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class RegisterProvider with ChangeNotifier {
  bool isLoading = false;
  bool isObscure = true;
  bool isObscure2 = true;
  bool isCheck = false;
  File? imageFile;
  String imageName = '';

  void isObscureText() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void isObscureText2() {
    isObscure2 = !isObscure2;
    notifyListeners();
  }

  void isChecked(value) {
    isCheck = value;
    notifyListeners();
  }

  // Pick Image
  Future<void> pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      imageName = image.name;
      notifyListeners();
    }
  }

  Future<void> pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imageFile = File(image.path);
      imageName = image.name;
      notifyListeners();
    }
  }

  ////////////////// register with email

  Future<void> register(userNameController, emailController, phoneController,
      passwordController, confirmPasswordController, context) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('https://cv.glamouride.org/api/register');
    var request = http.MultipartRequest("POST", url);

    // // Add text fields
    request.fields['name'] = userNameController;
    request.fields['email'] = emailController;
    request.fields['password'] = passwordController;
    request.fields['password_confirmation'] = confirmPasswordController;
    request.fields['phone'] = phoneController;

    request.files.add(
      http.MultipartFile(
        'profile_pic',
        imageFile!.readAsBytes().asStream(),
        imageFile!.lengthSync(),
        filename: imageName,
        contentType: MediaType('image', 'jpg'),
      ),
    );

    final response = await request.send();

    final result = await response.stream.bytesToString();
    final Map<String, dynamic> resultMap = json.decode(result);
    String message = resultMap['message'];
    if (response.statusCode == 200 && message != 'Request data missing') {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.whiteColor,
          content: Text(
            message,
            style: TextStyle(color: ColorConstant.buttonColor2),
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

      print('API response: ${response.stream}');
    } else {
      isLoading = false;
      notifyListeners();
      // Request failed, handle the error
      print('Error:>>> ${response.statusCode}');
      print('response data ${'message'}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.buttonColor2,
          content: Text(
            resultMap['errors'][0],
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }
}
