import 'dart:convert';
import 'package:colorvelvetus/Providers/ResetPassword.dart';
import 'package:http/http.dart' as http;
import 'package:colorvelvetus/Screens/PaintingWork/WorldMap.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaintingRootPage extends StatefulWidget {
  Map mArt;

  PaintingRootPage({
    super.key,
    required this.mArt,
  });

  @override
  State<PaintingRootPage> createState() => _PaintingRootPageState();
}

class _PaintingRootPageState extends State<PaintingRootPage> {
  bool isAdLoaded = false;
  ResetPasswordProvider colorChangeProvider = ResetPasswordProvider();
  //

  String message = '';
  String userID = '';
  String contestID = '';

  // get user profile
  Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/get-profile');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          userID = jsonData['user']['id'].toString();
        });
        return jsonData['user'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // get contests
  Future<List<dynamic>> getContests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/contests');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          contestID = jsonData['contests']['data'][0]['id'].toString();
        });
        return jsonData['contests']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Google Ads
  late BannerAd bannerAd;
  initBannerAdd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  //
  Future<void> addArtToContest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    String apiUrl = "https://cv.glamouride.org/api/add-to-contest";
    // print('id' + widget.coloringImage.artID);

    Map<String, dynamic> data = {
      'user_id': userID.toString(),
      'art_id': widget.mArt["id"].toString(),
      'contest_id': contestID.toString(),
    };
    print(data);

    // Convert the map to a JSON string
    String body = jsonEncode(data);

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myToken',
        },
        body: body,
      );

      // Check if the request was successful (status code 200)
      final jsonData = jsonDecode(response.body);
      setState(() {
        message = jsonData['message'];
      });
      if (response.statusCode == 200) {
        print(jsonData['message']);
        print("Data posted successfully");
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to post data');
      }
    } catch (error) {
      // setState(() {
      //     message = jsonData['message'];
      //   });
      print("Error: $error");
      // Handle the error
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAdd();
    getUserData();
    getContests();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height * 1.00,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            ColorConstant.buttonColor2,
            ColorConstant.buttonColor,
          ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ColorConstant.greyColor),
                            gradient: LinearGradient(colors: [
                              ColorConstant.buttonColor2,
                              ColorConstant.buttonColor,
                            ])),
                        child: Image.asset('assets/images/back.png'),
                      ),
                    ),
                    MyText(
                      myText: widget.mArt["name"],
                      // myText: widget.coloringImage.imageName,
                      fontweight: FontWeight.w500,
                      textColor: ColorConstant.whiteColor,
                      fontSize:
                          MediaQuery.of(context).size.width < 361 ? 18.0 : 22.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  'Art add to Contest !',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstant.blackColor,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.blackColor,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      addArtToContest();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor:
                                                  Colors.blue.shade300,
                                              content: Text(
                                                message,
                                                style: GoogleFonts.lato(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              )));

                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Add',
                                      style: GoogleFonts.lato(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstant.blackColor,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Image.asset(
                        'assets/images/contest.jpg',
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ],
                ),
              ),

              // image
              Container(
                height: MediaQuery.of(context).size.height * 0.70,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.buttonColor2,
                ),
                child: InteractiveViewer(
                  child: WorldMap(widget.mArt),
                  maxScale: 6.5,
                ),
              ),

              //
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(bottom: 20),
                height: 140,
                width: double.infinity,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.86,
                      decoration: BoxDecoration(
                        color: ColorConstant.blackColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: MyText(
                        myText: 'Pick a color from the palette to start',
                        fontweight: FontWeight.w400,
                        textColor: ColorConstant.whiteColor,
                        fontSize: 14.0,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0;
                              i < colorChangeProvider.colors.length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child:
                                  circleWidget(colorChangeProvider.colors[i]),
                            ),
                        ],
                      ),
                    ),
                    // isAdLoaded
                    //     ? SizedBox(
                    //         height: bannerAd.size.height.toDouble(),
                    //         width: bannerAd.size.width.toDouble(),
                    //         child: AdWidget(ad: bannerAd),
                    //       )
                    //     : const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // color palate start
  Widget circleWidget(Color mycolor) {
    return GestureDetector(
      onTap: () {
        // setState(() {

        WorldMap.pickerColor = mycolor;
        colorChangeProvider.colorsChange(mycolor);
        // selectedColor = mycolor;
        // });
      },
      child: Consumer<ResetPasswordProvider>(
        builder: (context, value, child) => Container(
          alignment: Alignment.center,
          height: value.selectedColor == mycolor ? 60 : 45,
          width: value.selectedColor == mycolor ? 60 : 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mycolor,
          ),
          child: Icon(
            Icons.check,
            size: 36,
            color: value.selectedColor == mycolor
                ? ColorConstant.greyColor
                : Colors.transparent,
          ),
        ),
      ),
    );
  }
}
