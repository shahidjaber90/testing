import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/LoginProvider.dart';
import 'package:colorvelvetus/Screens/ResetPassword.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Utils/LocalVariables.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';

class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  TextEditingController otpControllers = TextEditingController();
  int _currentCount = 60;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentCount > 0) {
          _currentCount--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Consumer<LoginProvider>(
      builder: (context, value, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                alignment: Alignment.topRight,
              )),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 10),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/rightStar.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SocialButton(
                      imageText: 'back',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      width: 39.0,
                      height: 39.0,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Please check your email',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.blackColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "We've sent a code to.",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.blackColor.withOpacity(0.40),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorConstant.blackColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 4,
                        controller: otpControllers,
                        keyboardType: TextInputType.number,
                        autoDisposeControllers: false,
                        animationType: AnimationType.fade,
                        textStyle: TextStyle(color: ColorConstant.blackColor),
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: 70,
                          fieldWidth: 70,
                          activeFillColor: ColorConstant.blackColor,
                          activeColor:
                              ColorConstant.greyColor.withOpacity(0.20),
                          selectedColor:
                              ColorConstant.greyColor.withOpacity(0.20),
                          inactiveColor: ColorConstant.blackColor,
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Please enter OTP Code",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1),
                                  )),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonWidget(
                      buttonText: 'Verify',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResetPassword(),
                          ),
                        );
                      },
                      gradient: LinearGradient(colors: [
                        ColorConstant.buttonColor2,
                        ColorConstant.buttonColor2.withOpacity(0.90),
                        ColorConstant.buttonColor,
                      ]),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Send code again",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: ColorConstant.greyColor,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () {
                            startCountdown();
                            setState(() {
                              _currentCount = 60;
                            });
                          },
                          child: Text(
                            _currentCount == 0 ? 'Resend' : '00:$_currentCount',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
