import 'package:flutter/material.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Screens/SignUpView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class OpeningView extends StatelessWidget {
  const OpeningView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height * 1.00,
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.62,
              left: 12,
              right: 12,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/BackGround.jpg',
                  ),
                  alignment: Alignment.topRight),
            ),
            child: Column(
              children: [
                MyText(
                  myText: 'Explore the app',
                  fontweight: FontWeight.w700,
                  textColor: ColorConstant.blackColor,
                  fontSize: 26.0,
                ),
                const SizedBox(
                  height: 6,
                ),
                MyText(
                  myText:
                      'Now your finances are in one place \nand always under control',
                  fontweight: FontWeight.w400,
                  textColor: ColorConstant.blackColor.withOpacity(0.30),
                  fontSize: 14.0,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ButtonWidget(
                  buttonText: 'Sign In',
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
                ButtonWidget(
                  buttonText: 'Create account',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpView(),
                      ),
                    );
                  },
                  color: ColorConstant.blackColor,
                  border: Border.all(
                    color: ColorConstant.greyColor,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
