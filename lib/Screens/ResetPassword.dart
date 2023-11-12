import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/ResetPassword.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Screens/PasswordChanged.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController password = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();
    return SafeArea(
        child: Consumer<ResetPasswordProvider>(
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
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.20,
                top: MediaQuery.of(context).size.width * 0.10,
              ),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/Star.png',
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
                height: MediaQuery.of(context).size.height * 0.97,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Column(
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
                          'Reset password',
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.blackColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Please type something you’ll remember",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: ColorConstant.blackColor.withOpacity(0.40),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(
                          height: 36,
                        ),
                        TextFieldWidget(
                          title: 'New password',
                          hintText: 'must be 8 characters',
                          controller: password,
                          suffixIcon: IconButton(
                            onPressed: value.isObscureText,
                            icon: value.isObscure
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: ColorConstant.greyColor
                                        .withOpacity(0.50),
                                  )
                                : Icon(
                                    Icons.visibility_outlined,
                                    color: ColorConstant.greyColor,
                                  ),
                          ),
                          isObscure: value.isObscure,
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        TextFieldWidget(
                          title: 'Confirm new password',
                          hintText: 'must be 8 characters',
                          controller: confirmPassword,
                          suffixIcon: IconButton(
                            onPressed: value.isObscureText2,
                            icon: value.isObscure2
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: ColorConstant.greyColor
                                        .withOpacity(0.50),
                                  )
                                : Icon(
                                    Icons.visibility_outlined,
                                    color: ColorConstant.greyColor,
                                  ),
                          ),
                          isObscure: value.isObscure2,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ButtonWidget(
                          buttonText: 'Reset Password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordChanged(),
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
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.5,
                            color: ColorConstant.greyColor,
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LogInView(),
                              ),
                            );
                          },
                          child: Text(
                            'Log in',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
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
