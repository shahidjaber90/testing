import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  String myText;
  final fontSize;
  FontWeight fontweight;
  Color textColor;
  final letterSpacing;
  final textAlign;
  MyText({
    super.key,
    required this.myText,
    this.fontSize,
    required this.fontweight,
    required this.textColor,
    this.letterSpacing,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      myText,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontweight,
        color: textColor,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
