import 'package:flutter/material.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    List aboutUsData = [
      {'name': 'betrapp@example.com', 'icon': 'email.png'},
      {'name': '(800)\n255-788-5698', 'icon': 'phone.png'},
      {'name': 'www.example.com', 'icon': 'website.png'},
      {'name': '193 Lorem Ipsem,London, 78987-2548', 'icon': 'location.png'},
    ];
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: ColorConstant.whiteColor,
        height: MediaQuery.of(context).size.height * 1.00,
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 30),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset('assets/images/backIcon.png')),
                  const Spacer(),
                  MyText(
                    myText: 'About Us',
                    fontweight: FontWeight.w600,
                    textColor: ColorConstant.blackColor,
                    fontSize: 24.0,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1.0,
            ),
            Image.asset('assets/images/aboutGroup.png'),
            const SizedBox(
              height: 24,
            ),
            MyText(
              myText: 'V9.3.20.530104',
              fontweight: FontWeight.w500,
              textColor: ColorConstant.greyColor.withOpacity(0.40),
              fontSize: 12.0,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MyText(
                myText:
                    'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus habitant morbi.',
                fontweight: FontWeight.w500,
                textColor: ColorConstant.greyColor.withOpacity(0.40),
                fontSize: 12.5,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: ListView.builder(
                  itemCount: aboutUsData.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.asset(
                            'assets/images/${aboutUsData[index]['icon']}'),
                        const SizedBox(
                          height: 6,
                        ),
                        MyText(
                          myText: aboutUsData[index]['name'],
                          fontweight: FontWeight.w400,
                          textColor: ColorConstant.greyColor.withOpacity(0.40),
                          fontSize: 15.0,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            MyText(
              myText: 'Copyright    2023 Media LLC.',
              fontweight: FontWeight.w500,
              textColor: ColorConstant.greyColor.withOpacity(0.40),
              fontSize: 14.0,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }
}
