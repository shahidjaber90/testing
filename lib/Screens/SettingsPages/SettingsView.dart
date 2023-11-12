import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/ChooseYourPlan.dart';
import 'package:colorvelvetus/Screens/SettingsPages/AboutUs.dart';
import 'package:colorvelvetus/Screens/SettingsPages/ManageAccount.dart';
import 'package:colorvelvetus/Screens/SettingsPages/TermsAndPolicies.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    List settingsData = [
      {'name': 'Manage Account', 'icon': 'account.png'},
      {'name': 'Notifications', 'icon': 'notification.png'},
      {'name': 'Support', 'icon': 'support.png'},
      {'name': 'Terms and Policies', 'icon': 'policy.png'},
      {'name': 'About us', 'icon': 'about.png'},
      {'name': 'Choose Your Plan', 'icon': 'logout.png'},
    ];

    LogOutProvider logoutProvider = LogOutProvider();

    List Pages = [
      const ManageAccount(),
      const TermAndPolicies(),
      const AboutUs(),
      const TermAndPolicies(),
      const AboutUs(),
      const ChooseYourPlan(),
    ];
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: ColorConstant.whiteColor,
        height: MediaQuery.of(context).size.height * 1.00,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/images/backIcon.png')),
                const Spacer(),
                MyText(
                  myText: 'Settings',
                  fontweight: FontWeight.w600,
                  textColor: ColorConstant.blackColor,
                  fontSize: 24.0,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 360,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: settingsData.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pages[index],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      height: 52,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  'assets/images/${settingsData[index]['icon']}'),
                              const SizedBox(
                                width: 10,
                              ),
                              MyText(
                                myText: settingsData[index]['name'],
                                fontweight: FontWeight.w500,
                                textColor: settingsData[index]['name'] ==
                                        'Choose Your Plan'
                                    ? ColorConstant.buttonColor2
                                    : ColorConstant.blackColor,
                                fontSize: 15.0,
                              ),
                            ],
                          ),
                          Image.asset('assets/images/next.png'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // ignore: use_build_context_synchronously
                await logoutProvider
                    .logoutFunction(context)
                    .then((value) => prefs.remove('getaccesToken'));
                final GoogleSignIn googleSignIn = GoogleSignIn();
                await googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                print('logout successfully');

                // logoutProvider.logoutFunction(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: 52,
                width: double.infinity,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/logout.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        MyText(
                          myText: 'Logout',
                          fontweight: FontWeight.w500,
                          textColor: ColorConstant.blackColor,
                          fontSize: 15.0,
                        ),
                      ],
                    ),
                    Image.asset('assets/images/next.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
