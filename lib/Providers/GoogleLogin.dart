import 'dart:convert';

import 'package:colorvelvetus/Screens/HomePage.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GoogleServices {
  bool isLoading = false;
  String? accessTokens;

  Future signinWithGoogle(context) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    print(gUser.email);
    print(gUser.displayName);
    print(gUser.photoUrl);
    print('Social Login Start**************');
    print('Social name :: ${gUser.displayName}');
    print('Social email :: ${gUser.email}');
    print('PHOTO URL:::: ${gUser.photoUrl}');
    print('USER ID :::: ${gUser.id}');
    print('Social access token:: ${gAuth.accessToken}');
    print('Social Login End**************');

    await FirebaseAuth.instance.signInWithCredential(credential);
    await socialLogin(
      context,
      gUser,
    );
  }

  // social login
  Future<void> socialLogin(
    context,
    GoogleSignInAccount googleUser,
  ) async {
    isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final url =
        Uri.parse('https://cv.glamouride.org/api/authorized/google/callback');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'login_type': 'google',
      'email': googleUser.email,
      'name': googleUser.displayName,
    });

    final response = await http.post(url, headers: headers, body: body);

    var responseData = jsonDecode(response.body);
    print("success:>>> ${responseData['message']}");
    var sub_message = responseData['sub_message'];
    await prefs.setString('sub_message', sub_message);
    print(googleUser.displayName);
    print(googleUser.email);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.buttonColor2,
          content: Text(
            'Account Created Successfully.',
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      accessTokens = responseData['access_token'];
      await prefs.setString('getaccesToken', accessTokens!);
      print('api ::: $accessTokens');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

      print('API response: ${response.body}');
    } else {
      isLoading = false;
      print('Status Code:>>> ${response.statusCode}');
      print('Response Headers:>>> ${response.headers}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'SignUp Failed: This email already exists.',
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }

  //
}
