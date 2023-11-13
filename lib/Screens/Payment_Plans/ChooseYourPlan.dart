import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChooseYourPlan extends StatefulWidget {
  const ChooseYourPlan({super.key});

  @override
  State<ChooseYourPlan> createState() => _ChooseYourPlanState();
}

class _ChooseYourPlanState extends State<ChooseYourPlan> {
  int currentIndex = 0;
  String chooseYourPlan = '';
  String prizeID = '';
  String customer_subscription_secret = '';
  String subscription_id = '';
  bool isLoading = false;
  String payment = '';

  List<Map<String, dynamic>> data = [];
  Future<List<dynamic>> getSubscription() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url =
        Uri.parse('https://cv.glamouride.org/api/get-subscriptions');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
      // 'Authorization': 'Bearer 56|KlifdgZ3686pwfB3wwIsfkaEeaZBsbAf3g2vhdhx89312d7a',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> datas = json.decode(response.body);
        if (datas['success'] == 'Subscriptions available') {
          List<Map<String, dynamic>> result =
              List<Map<String, dynamic>>.from(datas['data']);
          setState(() {
            data = result;
            isLoading = false;
          });
        }
        return datas['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // get subscription id
  Future getSubscriptionID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    try {
      final response = await http.post(
        Uri.parse('https://cv.glamouride.org/api/create-subscription-id'),
        headers: {
          'Authorization': 'Bearer $myToken',
        },
        body: jsonEncode({
          'price_id': prizeID,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          customer_subscription_secret =
              jsonData['customer_subscription_secret'].toString();
          print(customer_subscription_secret);
        });
        return jsonData['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // payment stripe
  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent('16', 'USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData!['client_secret'],
        setupIntentClientSecret:
            paymentIntentData![customer_subscription_secret.toString()],
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'US',
          testEnv: true,
        ),
        style: ThemeMode.dark,
        merchantDisplayName: 'Shahid',
      ));
      displayPaymentSheet();
    } catch (e) {
      print('Exception: ${e.toString()}');
    }
  }

  calculateAmount(String amount) {
    final price = int.parse(amount) * 100;
    return price.toString();
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51Nze4zBoWpCWkiM4ttwtFS1ce5s0q7qw5MkTInYkeuJ7QbtHzL1Xoim0zxbAmmP6ijXaOVY6gk32yrJIzXMhegBX000lhFtsxI',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body.toString());
    } catch (e) {
      print('Exception: ${e.toString()}');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successfully'),
        ),
      );
    } on StripeException catch (e) {
      print('Exception ' + e.toString());
      print('Payment fail');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                      'assets/images/Star.png',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              height: MediaQuery.of(context).size.height * 0.75,
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
                    'Choose your plan',
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: ColorConstant.blackColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    "To complete the sign up process, please make the payment",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: ColorConstant.blackColor.withOpacity(0.40),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          color: ColorConstant.blackColor.withOpacity(0.40),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: ColorConstant.buttonColor2,
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: MediaQuery.of(context).size.height * 0.47,
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  height: 80,
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    gradient: currentIndex == index
                                        ? LinearGradient(colors: [
                                            ColorConstant.buttonColor2,
                                            ColorConstant.buttonColor,
                                          ])
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                    border: currentIndex == index
                                        ? null
                                        : Border.all(
                                            color: ColorConstant.greyColor
                                                .withOpacity(0.60),
                                          ),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                        prizeID = data[index]['price_id'];
                                        payment =
                                            data[index]['amount'].toString();
                                        print(
                                            'payment plan selected: $payment');
                                        print(data[index]['name']);
                                        print(data[index]['amount']);
                                        print(data[index]['currency']);
                                        print(data[index]['price_id']);
                                        getSubscriptionID();
                                      });
                                    },
                                    title: Text(
                                      data[index]['description'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: currentIndex == index
                                            ? ColorConstant.whiteColor
                                            : ColorConstant.blackColor,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            '\$${data[index]['amount']} / mo',
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: currentIndex == index
                                                  ? ColorConstant.whiteColor
                                                  : ColorConstant.blackColor,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          Text(
                                            ' (${data[index]["currency"]})'
                                                .toUpperCase(),
                                            style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: currentIndex == index
                                                  ? ColorConstant.whiteColor
                                                  : ColorConstant.blackColor,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.radio_button_checked,
                                      color: ColorConstant.whiteColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                  isLoading
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: ButtonWidget(
                                buttonText: 'Click to Payment',
                                gradient: LinearGradient(colors: [
                                  ColorConstant.buttonColor2,
                                  ColorConstant.buttonColor,
                                ]),
                                onTap: () async {
                                  await makePayment();
                                },
                              ),
                            ),
                          ],
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
    ));
  }
}
