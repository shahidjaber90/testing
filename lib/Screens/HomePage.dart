import 'package:colorvelvetus/Screens/OpeningView.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/ChooseYourPlan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorvelvetus/Screens/ContestPage.dart';
import 'package:colorvelvetus/Screens/Home.dart';
import 'package:colorvelvetus/Screens/UserProfile.dart';
import 'package:colorvelvetus/Screens/News.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 10),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(48),
                gradient: LinearGradient(colors: [
              ColorConstant.buttonColor2.withOpacity(0.75),
              ColorConstant.buttonColor.withOpacity(0.75),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bottomNavIndex == 0
                          ? SvgPicture.asset(
                              'assets/svg/ActiveHome.svg',
                              height: 24,
                              width: 24,
                            )
                          : SvgPicture.asset(
                              'assets/svg/House.svg',
                              height: 24,
                              width: 24,
                            ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'Home',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 0
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.70),
                        fontweight: FontWeight.w500,
                      ),
                    ],
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
                              : const ContestPage();
                      _bottomNavIndex = 1;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/contest.svg',
                        height: 20,
                        width: 20,
                        color: _bottomNavIndex == 1
                            ? Colors.blueGrey.shade900
                            : ColorConstant.greyColor.withOpacity(0.70),
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
                      _bottomNavIndex = 2;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bottomNavIndex == 2
                          ? SvgPicture.asset(
                              'assets/svg/ActiveProfile.svg',
                              height: 24,
                              width: 24,
                            )
                          : SvgPicture.asset(
                              'assets/svg/Profile.svg',
                              height: 24,
                              width: 24,
                            ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'User',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 2
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
                      currentScreen = const News();
                      _bottomNavIndex = 3;
                    });
                  },
                  // minWidth: 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _bottomNavIndex == 3
                          ? SvgPicture.asset(
                              'assets/svg/ActiveHeart.svg',
                              height: 20,
                              width: 20,
                            )
                          : SvgPicture.asset(
                              'assets/svg/Heart.svg',
                              height: 20,
                              width: 20,
                            ),
                      const SizedBox(height: 2),
                      MyText(
                        myText: 'My Art',
                        fontSize: 14.0,
                        textColor: _bottomNavIndex == 3
                            ? ColorConstant.whiteColor
                            : ColorConstant.greyColor.withOpacity(0.70),
                        fontweight: FontWeight.w500,
                      ),
                    ],
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
