import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // bool isSwitched = false;
    // bool isSwitched2 = false;
    // bool isSwitched3 = false;
    List settings = [
      {
        'title': 'Highlight Areas',
        'img': 'assets/images/google.png',
        'arrow': Icon(
          Icons.arrow_circle_right_outlined,
          color: ColorConstant.whiteColor,
        ),
      },
      {
        'title': 'Dark Mode',
        'img': 'assets/images/google.png',
        'arrow': Icon(
          Icons.arrow_circle_right_outlined,
          color: ColorConstant.whiteColor,
        ),
      },
      {
        'title': 'Show Colored Pictures',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Auto-Switch',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Fill Animation',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
    ];
    List settings2 = [
      {
        'title': 'Vibration',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Sound Effect',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
    ];
    List settings3 = [
      {
        'title': 'Blocked Pictures',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Clear Cache',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
    ];
    List proList = [
      {
        'title': 'Remove Watermark',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Go to Store',
        'img': 'assets/images/google.png',
        'arrow': const Text(''),
      },
    ];
    List settings4 = [
      {
        'title': 'FAQ',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Contact Us',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Privacy Policy',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
      {
        'title': 'Terms of Use',
        'img': 'assets/images/google.png',
        'arrow': const ToggleSwitch(),
      },
    ];

    final screenWidth = MediaQuery.of(context).size.width * 1.00;
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorConstant.whiteColor,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: MyText(
            myText: 'Settings',
            fontweight: FontWeight.w500,
            textColor: ColorConstant.whiteColor,
            fontSize: 40.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardWidget(
                cardColor: ColorConstant.purple2Color,
                height: 80.0,
                width: screenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/images/google.png'),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Last Synced: 03:57',
                            style: GoogleFonts.katibeh(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w300,
                              color: ColorConstant.whiteColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_circle_right_outlined,
                        color: ColorConstant.whiteColor,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 14),
                height: 260,
                width: screenWidth,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: ColorConstant.purple2Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settings.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(settings[index]['img']),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            settings[index]['title'],
                            style: GoogleFonts.katibeh(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.whiteColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Spacer(),
                          settings[index]['arrow'],
                        ],
                      ),
                    );
                  },
                ),
              ),
              // 3rd
              Container(
                alignment: Alignment.center,
                height: 104,
                width: screenWidth,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: ColorConstant.purple2Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settings2.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(settings2[index]['img']),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            settings2[index]['title'],
                            style: GoogleFonts.katibeh(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.whiteColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Spacer(),
                          settings2[index]['arrow'],
                        ],
                      ),
                    );
                  },
                ),
              ),
              // 4th
              Container(
                alignment: Alignment.center,
                height: 104,
                width: screenWidth,
                margin: const EdgeInsets.symmetric(vertical: 14),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: ColorConstant.purple2Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settings3.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(settings3[index]['img']),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            settings3[index]['title'],
                            style: GoogleFonts.katibeh(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.whiteColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          // const Spacer(),
                          // settings2[index]['arrow'],
                        ],
                      ),
                    );
                  },
                ),
              ),
              // 5th
              Container(
                alignment: Alignment.center,
                height: 104,
                width: screenWidth,
                margin: const EdgeInsets.symmetric(vertical: 14),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: proList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(proList[index]['img']),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            proList[index]['title'],
                            style: GoogleFonts.katibeh(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.blackColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Spacer(),
                          proList[index]['arrow'],
                        ],
                      ),
                    );
                  },
                ),
              ),
              // 6th
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 14),
                height: 210,
                width: screenWidth,
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: ColorConstant.purple2Color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: settings4.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(settings4[index]['img']),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            settings4[index]['title'],
                            style: GoogleFonts.katibeh(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.whiteColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          // const Spacer(),
                          // settings[index]['arrow'],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

// toggle button

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Transform.scale(
          scale: 1.2,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: ColorConstant.whiteColor,
            activeTrackColor: Colors.deepPurple.shade700,
            inactiveThumbColor: ColorConstant.whiteColor,
            inactiveTrackColor: Colors.deepPurple.shade200,
          )),
    ]);
  }
}
