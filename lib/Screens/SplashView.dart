import 'dart:async';
import 'package:colorvelvetus/Screens/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Screens/OpeningView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> isLogged() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('getaccesToken') ?? '';
    if (accessToken.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OpeningView()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () async {
      await isLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1.00,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/Splash.png'),
                    alignment: Alignment.topRight),
              ),
              child: Image.asset('assets/images/SplashLogo.png'),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 30),
              height: MediaQuery.of(context).size.height * 1.00,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, Welcome!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.blackColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Image.asset(
                    'assets/images/hi.png',
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
