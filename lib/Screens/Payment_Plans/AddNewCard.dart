import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/PaymentProvider.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/Payment.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';

class AddNewCard extends StatelessWidget {
  const AddNewCard({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController cardNumber = TextEditingController();
    TextEditingController cardName = TextEditingController();
    TextEditingController cardExpire = TextEditingController();
    TextEditingController cvv = TextEditingController();
    TextEditingController zipCode = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Consumer<PaymentProvider>(
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
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/rightStar.png',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SocialButton(
                      imageText: 'back',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      width: 39.0,
                      height: 39.0,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Add card information',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.blackColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstant.greyColor.withOpacity(0.60)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/camera.png'),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Scan your card',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorConstant.greyColor,
                            ),
                          ),
                          const Spacer(),
                          Image.asset('assets/images/next.png'),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 1,
                          color: ColorConstant.greyColor,
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'or',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.blackColor,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 1,
                          color: ColorConstant.greyColor,
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Enter your card information",
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
                    TextFieldWidget(
                      title: 'CARD NUMBER',
                      hintText: '2344 5655 4586 4356',
                      controller: cardNumber,
                      isObscure: false,
                      suffixIcon: Image.asset('assets/images/Mastercard.png'),
                      fontWeight: FontWeight.w800,
                      color: ColorConstant.greyColor,
                    ),
                    TextFieldWidget(
                      title: 'NAME ON CARD',
                      hintText: 'JUSTIN SKYE',
                      controller: cardName,
                      isObscure: false,
                      fontWeight: FontWeight.w800,
                      color: ColorConstant.greyColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.40,
                          child: TextFieldWidget(
                            title: 'EXPIRY DATE',
                            hintText: '09/2025',
                            controller: cardExpire,
                            isObscure: false,
                            fontWeight: FontWeight.w800,
                            color: ColorConstant.greyColor,
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.45,
                          child: TextFieldWidget(
                            title: 'CVV',
                            hintText: '123',
                            controller: cvv,
                            isObscure: false,
                            fontWeight: FontWeight.w800,
                            color: ColorConstant.blackColor,
                          ),
                        ),
                      ],
                    ),
                    TextFieldWidget(
                      title: 'ZIP CODE',
                      hintText: '90120',
                      controller: zipCode,
                      isObscure: false,
                      fontWeight: FontWeight.w800,
                      color: ColorConstant.greyColor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonWidget(
                      buttonText: 'Add your card',
                      gradient: LinearGradient(colors: [
                        ColorConstant.buttonColor2,
                        ColorConstant.buttonColor,
                      ]),
                      onTap: () {
                        Navigator.pushReplacement(
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
