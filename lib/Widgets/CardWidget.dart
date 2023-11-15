import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  final height;
  double width;
  final Widget child;
  Color cardColor;
  CardWidget({
    super.key,
    this.height,
    required this.width,
    required this.child,
    this.cardColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(6.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}
