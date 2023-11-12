import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/LoginProvider.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Screens/OTPView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Utils/LocalVariables.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
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
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/LeftStar3.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          'Forgot password?',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.blackColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Don’t worry! It happens. Please enter the email associated with your account.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.blackColor.withOpacity(0.40),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldWidget(
                          title: 'Email address',
                          hintText: 'Enter Your email address',
                          controller: email,
                          isObscure: false,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ButtonWidget(
                          buttonText: 'Send code',
                          onTap: () {
                            setState(() {
                              userEmail = email.text;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OTPView(),
                              ),
                            );
                            print(userEmail);
                            print(email.text);
                          },
                          gradient: LinearGradient(colors: [
                            ColorConstant.buttonColor2,
                            ColorConstant.buttonColor2.withOpacity(0.90),
                            ColorConstant.buttonColor,
                          ]),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Remember password?",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: ColorConstant.blackColor.withOpacity(0.30),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInView(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.blackColor,
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
