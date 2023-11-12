import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/PaymentProvider.dart';
import 'package:colorvelvetus/Screens/HomePage.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/AddNewCard.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent();
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          googlePay: PaymentSheetGooglePay(merchantCountryCode: 'USD'),
          merchantDisplayName: 'Shahid Jaber',
          customerId: paymentIntentData!['Customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
        ));
        displayPaymentSheet();
      }
    } catch (e) {}
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  // payment param
  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount('1500'),
        'currency': 'USD',
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Autherization':
              'Bearer sk_test_51Nze4zBoWpCWkiM4ttwtFS1ce5s0q7qw5MkTInYkeuJ7QbtHzL1Xoim0zxbAmmP6ijXaOVY6gk32yrJIzXMhegBX000lhFtsxI',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {}
  }

  // display sheet

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('Payment Successfull');
    } on Exception catch (e) {
      if (e is StripeException) {
        print('error from $e');
      } else {
        print('unforesson error');
      }
    } catch (e) {
      print('catch e error: $e');
    }
  }

  // void makePayment() async {
  //   try {
  //     print('Start 1');
  //     paymentIntent = await createPaymentIntent();
  //     PaymentSheetGooglePay gPay = const PaymentSheetGooglePay(
  //       merchantCountryCode: "US",
  //       currencyCode: 'USD',
  //       amount: '1050',
  //       testEnv: true,
  //     );
  //     print('Start 2');
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //       paymentIntentClientSecret: paymentIntent!["client_secret"],
  //       style: ThemeMode.dark,
  //       merchantDisplayName: 'Shahid Jaber',
  //       googlePay: gPay,
  //     ));
  //     displayPaymentSheet();
  //   } catch (e) {}
  // }

  // void displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet();
  //     print('Done');
  //   } catch (e) {}
  //   print('Payment Fail');
  // }

  // createPaymentIntent() async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': '1050',
  //       'currency': 'USD',
  //     };

  //     http.Response response = await http.post(
  //         Uri.parse("https//api.stripe.com/v1/payment_intents"),
  //         body: body,
  //         headers: {
  //           'Authorization':
  //               'Bearer sk_test_51Nze4zBoWpCWkiM4ttwtFS1ce5s0q7qw5MkTInYkeuJ7QbtHzL1Xoim0zxbAmmP6ijXaOVY6gk32yrJIzXMhegBX000lhFtsxI',
  //           'Content-Type': 'application/x-www-form-urlencoded',
  //         });
  //     return json.decode(response.body);
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  List paymentCard = [
    {
      'title': 'Mastercard/EuroCard  ****2390',
      'type': 'Justin Skye',
      'expire': 'Expires 08/2029',
    },
    {
      'title': 'VisaCard  ****2450',
      'type': 'Justin Skye',
      'expire': 'Expires 08/2029',
    },
  ];
  double sWidth = 360;
  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.10,
                top: MediaQuery.of(context).size.width * 0.12,
              ),
              height: MediaQuery.of(context).size.height * 1.00,
              width: MediaQuery.of(context).size.width * 1.00,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/Star.png',
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
                      'Checkout',
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
                      "Payment method",
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
                    Container(
                      height: 55,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConstant.greyColor.withOpacity(0.60)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/card.png'),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Card',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.blackColor,
                            ),
                          ),
                          const Spacer(),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(99))),
                              value: value.isCheck,
                              onChanged: (values) {
                                value.isChecked(values);
                                value.chooseIndex(values);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddNewCard(),
                              ),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 170,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  ColorConstant.buttonColor2,
                                  ColorConstant.buttonColor,
                                ])),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/add.png'),
                                const SizedBox(width: 8),
                                Text(
                                  'Add new card',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: ColorConstant.whiteColor,
                                    letterSpacing: 0.3,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: paymentCard.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              value.chooseIndex(index);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              height: 100,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorConstant.greyColor
                                        .withOpacity(0.60),
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 80,
                                    width: 40,
                                    child: Radio(
                                      activeColor: ColorConstant.buttonColor2,
                                      value: paymentCard[index]['title'],
                                      groupValue: value.paymentCard,
                                      onChanged: (val) {
                                        value.paymentWith(val);
                                        print(value.paymentCard);
                                      },
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        paymentCard[index]['title'],
                                        style: GoogleFonts.inter(
                                          fontSize: sWidth < 360 ? 14 : 16,
                                          fontWeight: FontWeight.w600,
                                          color: ColorConstant.blackColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      Text(
                                        paymentCard[index]['type'],
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.blackColor,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      Text(
                                        paymentCard[index]['expire'],
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstant.blackColor
                                              .withOpacity(0.40),
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ButtonWidget(
                      buttonText: 'Checkout',
                      gradient: LinearGradient(colors: [
                        ColorConstant.buttonColor2,
                        ColorConstant.buttonColor,
                      ]),
                      onTap: () {
                        makePayment();
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomePage(),
                        //   ),
                        // );
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
