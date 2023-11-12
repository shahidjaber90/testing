import 'package:flutter/material.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class ManageAccount extends StatelessWidget {
  const ManageAccount({super.key});

  @override
  Widget build(BuildContext context) {
    List aboutUsData = [
      {'title': 'Phone Number', 'details': '+1230****943'},
      {'title': 'Email', 'details': 'ex***le@gmail.com'},
      {'title': 'Payment Method', 'details': 'Card *************'},
      {'title': 'Password', 'details': ''},
      {'title': 'Delete account', 'details': ''},
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
                    myText: 'Manage account',
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
            const SizedBox(
              height: 24,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 70,
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/john_doe.png',
                        height: 32,
                        width: 32,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MyText(
                        myText: 'John Doe',
                        fontweight: FontWeight.w500,
                        textColor: ColorConstant.blackColor,
                        fontSize: 15.0,
                      ),
                      const Spacer(),
                      Image.asset('assets/images/next.png'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ).copyWith(top: 14),
                    child: const Divider(),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: aboutUsData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 70,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyText(
                              myText: aboutUsData[index]['title'],
                              fontweight: FontWeight.w500,
                              textColor: aboutUsData[index]['title'] ==
                                      'Delete account'
                                  ? Colors.red
                                  : ColorConstant.blackColor,
                              fontSize: 15.0,
                            ),
                            Row(
                              children: [
                                MyText(
                                  myText: aboutUsData[index]['details'],
                                  fontweight: FontWeight.w200,
                                  textColor:
                                      ColorConstant.greyColor.withOpacity(0.50),
                                  fontSize: 15.0,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset('assets/images/next.png'),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          child: Divider(),
                        )
                      ],
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    ));
  }
}
