import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  String buttonText;
  void Function()? onTap;
  final gradient;
  final color;
  final border;
  final fontWeight;
  ButtonWidget({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.gradient,
    this.color = Colors.white,
    this.border,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        height: 55,
        width: MediaQuery.of(context).size.width * 1.00,
        decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
            border: border),
        child: Text(
          buttonText,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: fontWeight,
            letterSpacing: 0.5,
            color: color,
          ),
        ),
      ),
    );
  }
}
