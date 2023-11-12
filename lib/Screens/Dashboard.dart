// import 'package:flutter/material.dart';
// import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:colorvelvetus/Screens/Daily.dart';
// import 'package:colorvelvetus/Screens/Home.dart';
// import 'package:colorvelvetus/Screens/UserProfile.dart';
// import 'package:colorvelvetus/Screens/News.dart';
// import 'package:colorvelvetus/Utils/Colors.dart';
// import 'package:colorvelvetus/Widgets/MyText.dart';

// class HomePage2 extends StatefulWidget {
//   HomePage2({super.key});

//   @override
//   State<HomePage2> createState() => _HomePage2State();
// }

// class _HomePage2State extends State<HomePage2> {
//   int currentPage = 0;
//   GlobalKey bottomNavigationKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: // Showing the body according to the currentPage index.
//               (currentPage == 0)
//                   ? const Home()
//                   : (currentPage == 1)
//                       ? const Daily()
//                       : const UserProfile(),
//         ),
//         bottomNavigationBar: FancyBottomNavigation(
//           initialSelection: currentPage,
//           key: bottomNavigationKey,
//           circleColor: ColorConstant.buttonColor.withOpacity(0.60),
//           inactiveIconColor: ColorConstant.greyColor,
//           barBackgroundColor: ColorConstant.buttonColor2,
//           textColor: ColorConstant.whiteColor,
//           activeIconColor: ColorConstant.whiteColor,
//           tabs: [
//             TabData(
//               iconData: Icons.home_outlined,
//               title: "Home",
//               onclick: () {},
//             ),
//             TabData(
//               iconData: Icons.shopping_bag_outlined,
//               title: "My Cart",
//               onclick: () {},
//             ),
//             TabData(
//                 iconData: Icons.person_2_outlined,
//                 title: "Profile",
//                 onclick: () {}),
//           ],
//           // When tab changes we also called the setState method to change the currentpage
//           onTabChangedListener: (indexPage) {
//             setState(() {
//               currentPage = indexPage;
//             });
//           },
//         ),
//       ),
//     );
//   }
// }

// // Svg Widget for Navigation
// Widget customSvgIcon(String assetName, int index) {
//   return SvgPicture.asset(
//     'assets/svg/$assetName.svg',
//     width: 24,
//     height: 24,
//     color: index == index ? ColorConstant.whiteColor : ColorConstant.greyColor,
//   );
// }
