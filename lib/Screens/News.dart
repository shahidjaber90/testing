import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    List itemName = [
      'Game Time!',
      'Weekly Best Pic',
      'Dark Romance',
      'New Feature is Coming',
      'Halloween Game',
      'Best Pic Voting',
      'Join us on Facebook',
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: ColorConstant.greyColor.withOpacity(0.20),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    myText: 'News',
                    fontweight: FontWeight.w500,
                    textColor: ColorConstant.blackColor,
                    fontSize: 36.0,
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.calendar_month,
                  //     color: ColorConstant.whiteColor,
                  //   ),
                  // ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: itemName.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: CardWidget(
                        height: screenWidth * 0.40,
                        width: screenWidth,
                        child: Row(
                          children: [
                            CardWidget(
                              height: screenWidth * 0.40,
                              width: screenWidth * 0.40,
                              child: Image.network(
                                'https://cv.glamouride.org/arts/1696774674-pT5d68kT9.gif',
                                fit: BoxFit.cover,
                              ),
                            ),
                            CardWidget(
                              height: screenWidth * 0.40,
                              width: screenWidth * 0.40,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        itemName[index],
                                        style: GoogleFonts.katibeh(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.backgroundColor,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      Text(
                                        'Enjoy the coloring moment',
                                        style: GoogleFonts.katibeh(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.backgroundColor,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 24,
                                    width: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.purpleColor,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      'GO!',
                                      style: GoogleFonts.katibeh(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.whiteColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
