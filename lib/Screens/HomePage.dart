import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorvelvetus/Screens/ContestPage.dart';
import 'package:colorvelvetus/Screens/Home.dart';
import 'package:colorvelvetus/Screens/UserProfile.dart';
import 'package:colorvelvetus/Screens/News.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavIndex = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Home();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: currentScreen),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: ColorConstant.buttonColor2,
        //   elevation: 0,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => HomePage(),
        //         ));
        //   },
        //   child: const Icon(Icons.home),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 10),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              ColorConstant.buttonColor2,
              ColorConstant.buttonColor,
            ])),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = const Home();
                      _bottomNavIndex = 0;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/home.svg',
                        color: _bottomNavIndex == 0
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                      ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'Home',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 0
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = const ContestPage();
                      _bottomNavIndex = 1;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/contest.svg',
                        height: 24,
                        width: 24,
                        color: _bottomNavIndex == 1
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                      ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'Contest',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 1
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = const UserProfile();
                      _bottomNavIndex = 3;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/user.svg',
                        color: _bottomNavIndex == 3
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                      ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'User',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 3
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.60),
                        fontweight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     MaterialButton(
                //       onPressed: () {
                //         setState(() {
                //           currentScreen = const News();
                //           _bottomNavIndex = 2;
                //         });
                //       },
                //       minWidth: 40,
                //       child: Column(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/svg/bag.svg',
                //             color: _bottomNavIndex == 2
                //                 ? ColorConstant.whiteColor
                //                 : ColorConstant.greyColor.withOpacity(0.60),
                //           ),
                //           const SizedBox(height: 2),
                //           MyText(
                //             myText: 'News',
                //             fontSize: 12.0,
                //             textColor: _bottomNavIndex == 2
                //                 ? ColorConstant.whiteColor
                //                 : ColorConstant.greyColor.withOpacity(0.60),
                //             fontweight: FontWeight.w400,
                //           ),
                //         ],
                //       ),
                //     ),
                //     MaterialButton(
                //       onPressed: () {
                //         setState(() {
                //           currentScreen = const UserProfile();
                //           _bottomNavIndex = 3;
                //         });
                //       },
                //       minWidth: 40,
                //       child: Column(
                //         children: [
                //           SvgPicture.asset(
                //             'assets/svg/user.svg',
                //             color: _bottomNavIndex == 3
                //                 ? ColorConstant.whiteColor
                //                 : ColorConstant.greyColor.withOpacity(0.60),
                //           ),
                //           const SizedBox(height: 2),
                //           MyText(
                //             myText: 'My Painting',
                //             fontSize: 12.0,
                //             textColor: _bottomNavIndex == 3
                //                 ? ColorConstant.whiteColor
                //                 : ColorConstant.greyColor.withOpacity(0.60),
                //             fontweight: FontWeight.w400,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
