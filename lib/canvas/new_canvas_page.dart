// import 'package:animated_floating_buttons/widgets/animated_floating_action_button.dart';
import 'dart:convert';

import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:colorvelvetus/canvas/canvas_painter.dart';
import 'package:colorvelvetus/canvas/coloring_image.dart';
import 'package:colorvelvetus/canvas/touch_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewCanvasPage extends StatefulWidget {
  NewCanvasPage({
    Key? key,
    required this.coloringImage,
  }) : super(key: key);

  final ColoringImage coloringImage;

  @override
  _NewCanvasPageState createState() => _NewCanvasPageState();
}

class _NewCanvasPageState extends State<NewCanvasPage> {
  GlobalKey previewContainer = GlobalKey();
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  String userID = '';
  String contestID = '';
  String message = '';

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

  List<TouchPoints?> points = [];
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 5.0;
  Color selectedColor = Colors.cyan;
  List<Color> colors = [
    const Color(0XFFFFFFFF),
    const Color(0XFF000000),
    const Color.fromARGB(255, 251, 8, 8),
    const Color(0XFF8B0000),
    const Color.fromARGB(255, 127, 208, 95),
    const Color.fromARGB(255, 34, 147, 178),
    const Color(0XFFCD5C5C),
    const Color(0XFFDC143C),
    const Color(0XFFFF6347),
    const Color.fromARGB(255, 152, 72, 72),
    const Color.fromARGB(255, 203, 42, 176),
    const Color(0XFFE9967A),
    const Color(0XFFFFE4E1),
    const Color.fromARGB(255, 15, 75, 160),
    const Color.fromARGB(255, 180, 180, 180),
    const Color.fromARGB(255, 128, 124, 0),
    const Color(0XFF00008B),
    const Color.fromARGB(255, 134, 134, 193),
    const Color(0XFF4169E1),
    const Color(0XFF87CEFA),
    const Color(0XFFADD8E6),
    const Color(0XFF00BFFF),
    const Color(0XFF6495ED),
    const Color(0XFF89CFF0),
  ];

  // add art to contest
  Future<void> addArtToContest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    String apiUrl = "https://cv.glamouride.org/api/add-to-contest";

    Map<String, dynamic> data = {
      'user_id': userID.toString(),
      'art_id': widget.coloringImage.artID.toString(),
      'contest_id': contestID.toString(),
    };

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
    return RepaintBoundary(
      key: previewContainer,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 1.00,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(bottom: 20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  ColorConstant.buttonColor2,
                  ColorConstant.buttonColor,
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        isAdLoaded
                            ? SizedBox(
                                height: bannerAd.size.height.toDouble(),
                                width: bannerAd.size.width.toDouble(),
                                child: AdWidget(ad: bannerAd),
                              )
                            : const SizedBox(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    border: Border.all(
                                        color: ColorConstant.greyColor),
                                    gradient: LinearGradient(colors: [
                                      ColorConstant.buttonColor2,
                                      ColorConstant.buttonColor,
                                    ])),
                                child: Image.asset('assets/images/back.png'),
                              ),
                            ),
                            const Spacer(),
                            MyText(
                              myText: widget.coloringImage.imageName,
                              fontweight: FontWeight.w500,
                              textColor: ColorConstant.whiteColor,
                              fontSize: 24.0,
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
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
                                                    color: ColorConstant
                                                        .blackColor,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await addArtToContest();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Colors.blue
                                                                  .shade300,
                                                          content: Text(
                                                            message,
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )));

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Add',
                                                  style: GoogleFonts.lato(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorConstant
                                                        .blackColor,
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.share_outlined,
                                    color: ColorConstant.whiteColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      points.clear();
                                    });
                                  },
                                  child: MyText(
                                    myText: 'Clear',
                                    fontweight: FontWeight.w500,
                                    textColor: ColorConstant.whiteColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    //
                    Container(
                      height: 108,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.80,
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
                                for (var i = 0; i < colors.length; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6),
                                    child: circleWidget(colors[i]),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // color image
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    points.add(TouchPoints(
                        points: renderBox.globalToLocal(details.globalPosition),
                        paint: Paint()
                          ..strokeCap = strokeType
                          ..isAntiAlias = true
                          ..color = selectedColor
                          ..strokeWidth = strokeWidth));
                  });
                },
                onPanStart: (details) {
                  setState(() {
                    RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    points.add(TouchPoints(
                        points: renderBox.globalToLocal(details.globalPosition),
                        paint: Paint()
                          ..strokeCap = strokeType
                          ..isAntiAlias = true
                          ..color = selectedColor
                          ..strokeWidth = strokeWidth));
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    points.add(null);
                  });
                },
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: Image.network(
                            widget.coloringImage.imageAssetPath,
                            fit: BoxFit.contain,
                          )),
                    ),
                    Visibility(
                      visible: true,
                      child: CustomPaint(
                        // size: Size.infinite,
                        foregroundPainter: CanvasPainter(
                          points,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // floatingActionButton: AnimatedFloatingActionButton(
          //   fabButtons: fabOption(),
          //   colorEndAnimation: Colors.cyan,
          //   animatedIconData: AnimatedIcons.menu_close,
          // ),
        ),
      ),
    );
  }

  //
  Widget circleWidget(Color mycolor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = mycolor;
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: selectedColor == mycolor ? 60 : 45,
        width: selectedColor == mycolor ? 60 : 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mycolor,
        ),
        child: Icon(
          Icons.check,
          size: 36,
          color: selectedColor == mycolor
              ? ColorConstant.greyColor
              : Colors.transparent,
        ),
      ),
    );
  }

  //
}
