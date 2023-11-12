import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/LoginProvider.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';

class PasswordChanged extends StatelessWidget {
  const PasswordChanged({super.key});

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
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/background2.png'),
                alignment: Alignment.bottomLeft,
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
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 40, bottom: 24),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Image.asset(
                'assets/images/bottomStar.png',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    Image.asset(
                      'assets/images/Star2.png',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Password changed',
                      textAlign: TextAlign.center,
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
                      "Your password has been changed succesfully",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.blackColor.withOpacity(0.40),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ButtonWidget(
                      buttonText: 'Sign in',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LogInView(),
                          ),
                        );
                      },
                      gradient: LinearGradient(colors: [
                        ColorConstant.buttonColor2,
                        ColorConstant.buttonColor2.withOpacity(0.90),
                        ColorConstant.buttonColor,
                      ]),
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
