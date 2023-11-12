import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:flutter/material.dart';
import 'package:colorvelvetus/Utils/Colors.dart';

// ignore: must_be_immutable
class SocialButton extends StatelessWidget {
  String imageText;
  void Function()? onTap;
  final gradient;
  final color;
  final border;
  final height;
  final width;
  SocialButton({
    super.key,
    required this.imageText,
    required this.onTap,
    this.gradient,
    this.color = Colors.white,
    this.border,
    this.height = 55.0,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ColorConstant.greyColor.withOpacity(0.40),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/$imageText.png'),
              const SizedBox(
                width: 14,
              ),
              MyText(
                myText: 'Sign In with google',
                fontweight: FontWeight.w500,
                textColor: ColorConstant.buttonColor2,
                fontSize: 16.0,
              ),
            ],
          )),
    );
  }
}
