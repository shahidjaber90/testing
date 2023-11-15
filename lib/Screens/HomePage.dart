import 'package:colorvelvetus/Screens/ContestPages/AllContest.dart';
import 'package:colorvelvetus/Screens/Daily.dart';
import 'package:colorvelvetus/Screens/OpeningView.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/ChooseYourPlan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorvelvetus/Screens/ContestPage.dart';
import 'package:colorvelvetus/Screens/Home.dart';
import 'package:colorvelvetus/Screens/UserProfile.dart';
import 'package:colorvelvetus/Screens/MyArt.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavIndex = 5;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Home();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageStorage(bucket: bucket, child: currentScreen),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          isExtended: true,
          elevation: 2.0,
          onPressed: () {
            setState(() {
              currentScreen = const Home();
              _bottomNavIndex = 5;
            });
          },
          child: Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorConstant.buttonColor2,
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  ColorConstant.buttonColor2,
                  ColorConstant.buttonColor,
                ],
              ),
            ),
            child: SvgPicture.asset(
              'assets/svg/House.svg',
              height: 20,
              width: 20,
              color: _bottomNavIndex == 5
                  ? ColorConstant.whiteColor
                  : ColorConstant.greyColor.withOpacity(0.60),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5.0,
          child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
            decoration: BoxDecoration(
              color: ColorConstant.whiteColor,
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = DailyPage();
                      _bottomNavIndex = 0;
                    });
                  },
                  // minWidth: 40,
                  child: Container(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/home.svg',
                          height: 20,
                          width: 20,
                          color: _bottomNavIndex == 0
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          myText: 'Daily',
                          fontSize: 12.0,
                          textColor: _bottomNavIndex == 0
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.70),
                          fontweight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String sub_message =
                        prefs.getString('sub_message').toString();
                    setState(() {
                      currentScreen =
                          sub_message == "Your subscription has been ended"
                              ? const ChooseYourPlan()
                              : const AllContestPage();
                      _bottomNavIndex = 1;
                    });
                  },
                  // minWidth: 40,
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/search.svg',
                          height: 20,
                          width: 20,
                          color: _bottomNavIndex == 1
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          myText: 'Contest',
                          fontSize: 12.0,
                          textColor: _bottomNavIndex == 1
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                          fontweight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = const MyArt();
                      _bottomNavIndex = 2;
                    });
                  },
                  // minWidth: 40,
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/Heart.svg',
                          height: 20,
                          width: 20,
                          color: _bottomNavIndex == 2
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          myText: 'My Art',
                          fontSize: 12.0,
                          textColor: _bottomNavIndex == 2
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.70),
                          fontweight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                // 4
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentScreen = const UserProfile();
                      _bottomNavIndex = 3;
                    });
                  },
                  // minWidth: 40,
                  child: Container(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/user.svg',
                          height: 20,
                          width: 20,
                          color: _bottomNavIndex == 3
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                        ),
                        const SizedBox(height: 2),
                        MyText(
                          myText: 'User',
                          fontSize: 12.0,
                          textColor: _bottomNavIndex == 3
                              ? ColorConstant.buttonColor2
                              : ColorConstant.greyColor.withOpacity(0.60),
                          fontweight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
