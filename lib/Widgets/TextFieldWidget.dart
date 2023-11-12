import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  String hintText;
  final iconData;
  final suffixIcon;
  final controller;
  bool isObscure;
  final title;
  final fontWeight;
  final color;
  final validator;
  TextFieldWidget({
    super.key,
    required this.hintText,
    this.iconData,
    this.suffixIcon,
    required this.controller,
    required this.isObscure,
    this.title,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: fontWeight,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            obscureText: isObscure,
            validator: validator,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstant.greyColor.withOpacity(0.20)),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstant.greyColor.withOpacity(0.20)),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: ColorConstant.greyColor.withOpacity(0.20)),
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: ColorConstant.greyColor.withOpacity(0.50),
              ),
              prefixIcon: iconData,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
