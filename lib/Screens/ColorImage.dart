import 'package:flutter/material.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'dart:ui';

import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ColorImage extends StatefulWidget {
  final tapImage;
  String textImage;
  ColorImage({
    super.key,
    required this.tapImage,
    required this.textImage,
  });

  @override
  State<ColorImage> createState() => _ColorImageState();
}

class _ColorImageState extends State<ColorImage> {
  List<Color> colors = [
    const Color(0XFFFFFFFF),
    const Color(0XFF000000),
    const Color.fromARGB(255, 251, 8, 8),
    const Color(0XFF8B0000),
    const Color(0XFF800000),
    const Color(0XFFB22222),
    const Color(0XFFCD5C5C),
    const Color(0XFFDC143C),
    const Color(0XFFFF6347),
    const Color(0XFFF08080),
    const Color(0XFFFA8072),
    const Color(0XFFE9967A),
    const Color(0XFFFFE4E1),
    const Color.fromARGB(255, 15, 75, 160),
    const Color(0XFF191970),
    const Color(0XFF000080),
    const Color(0XFF00008B),
    const Color(0XFF0000CD),
    const Color(0XFF4169E1),
    const Color(0XFF87CEFA),
    const Color(0XFFADD8E6),
    const Color(0XFF00BFFF),
    const Color(0XFF6495ED),
    const Color(0XFF89CFF0),
  ];
  Color primaryColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1.00,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ColorConstant.buttonColor2,
            ColorConstant.buttonColor,
          ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 36,
                      width: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorConstant.greyColor),
                          gradient: LinearGradient(colors: [
                            ColorConstant.buttonColor2,
                            ColorConstant.buttonColor,
                          ])),
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                  MyText(
                    myText: widget.textImage,
                    fontweight: FontWeight.w500,
                    textColor: ColorConstant.whiteColor,
                    fontSize: 24.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        drawingPoints = [];
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            ColorConstant.buttonColor2,
                            ColorConstant.buttonColor,
                          ]),
                          border: Border.all(
                            color: ColorConstant.blackColor,
                          ),
                          borderRadius: BorderRadius.circular(14)),
                      child: MyText(
                        myText: 'Clear',
                        fontweight: FontWeight.w500,
                        textColor: ColorConstant.whiteColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.70,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(''),
                    // draw  color
                    GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          drawingPoints.add(
                            DrawingPoint(
                              details.localPosition,
                              Paint()
                                ..color = primaryColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round,
                            ),
                          );
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          drawingPoints.add(
                            DrawingPoint(
                              details.localPosition,
                              Paint()
                                ..color = primaryColor
                                ..isAntiAlias = true
                                ..strokeWidth = strokeWidth
                                ..strokeCap = StrokeCap.round,
                            ),
                          );
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          drawingPoints.add(null);
                        });
                      },
                      child: CustomPaint(
                        painter: _DrawingPainter(drawingPoints),
                        child: Container(
                          child: PhotoView(
                              imageProvider: NetworkImage(widget.tapImage)),
                          height: 400,
                          width: double.infinity,
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: NetworkImage(widget.tapImage),
                          // ),
                          //   ),
                        ),
                      ),
                    ),
                    // pick an Color
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                        color: ColorConstant.blackColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MyText(
                        myText: 'Pick a color from the palette to start',
                        fontweight: FontWeight.w400,
                        textColor: ColorConstant.whiteColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < colors.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: circleWidget(colors[i]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circleWidget(Color mycolor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          primaryColor = mycolor;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: primaryColor == mycolor ? 60 : 45,
        width: primaryColor == mycolor ? 60 : 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mycolor,
        ),
        child: Icon(
          Icons.check,
          size: 36,
          color: primaryColor == mycolor
              ? ColorConstant.greyColor
              : Colors.transparent,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints; // Use nullable list

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      final currentPoint = drawingPoints[i];
      final nextPoint = drawingPoints.elementAt(i + 1);

      if (currentPoint != null && nextPoint != null) {
        canvas.drawLine(
          currentPoint.offset,
          nextPoint.offset,
          currentPoint.paint,
        );
      } else if (currentPoint != null && nextPoint == null) {
        offsetsList.clear();
        offsetsList.add(currentPoint.offset);

        canvas.drawPoints(
          PointMode.points,
          offsetsList,
          currentPoint.paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
