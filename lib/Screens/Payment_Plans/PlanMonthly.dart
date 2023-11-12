import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/PlanMonthlyProvider.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/Payment.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';

class PlanMonthly extends StatelessWidget {
  const PlanMonthly({super.key});

  @override
  Widget build(BuildContext context) {
    // int currentIndex = 0;
    List planMonthly = [
      {'title': 'Lorem ipsem'},
      {'title': 'Lorem ipsem'},
      {'title': 'Lorem ipsem'},
      {'title': 'Lorem ipsem'},
      {'title': 'Lorem ipsem'},
    ];
    return SafeArea(
        child: Consumer<PlanMonthlyProvider>(
      builder: (context, value, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                alignment: Alignment.topRight,
              )),
            ),
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.width * 0.06,
              ),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/RightStar2.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 39,
                        width: 39,
                        decoration: BoxDecoration(
                          color: ColorConstant.whiteColor,
                          border: Border.all(
                            color: ColorConstant.greyColor,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset('assets/images/back.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Monthly',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.blackColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "What you’ll Get",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: ColorConstant.blackColor.withOpacity(0.40),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.36,
                      child: ListView.builder(
                        itemCount: planMonthly.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              value.chooseIndex(index);
                            },
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    height: 26,
                                    width: 26,
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            ColorConstant.buttonColor2,
                                            ColorConstant.buttonColor,
                                          ],
                                        )),
                                    child: Checkbox(
                                      activeColor: Colors.transparent,
                                      side: BorderSide.none,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(99))),
                                      value: value.currentIndex == index
                                          ? value.isCheck
                                          : false,
                                      onChanged: (values) {
                                        value.isChecked(values);
                                        value.chooseIndex(values);
                                      },
                                    ),
                                  ),
                                  MyText(
                                    myText: planMonthly[index]['title'],
                                    fontweight: FontWeight.w600,
                                    textColor: ColorConstant.greyColor,
                                    fontSize: 16.0,
                                    letterSpacing: 0.5,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      color: ColorConstant.greyColor.withOpacity(0.80),
                    )),
                    Text(
                      '\$29,99 / month',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: ColorConstant.blackColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    ButtonWidget(
                      buttonText: 'Continue to payment',
                      gradient: LinearGradient(colors: [
                        ColorConstant.buttonColor2,
                        ColorConstant.buttonColor,
                      ]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Payment(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
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
