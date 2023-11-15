import 'dart:convert';
import 'dart:io';
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
  String artID;

  PaintingRootPage({
    super.key,
    required this.mArt,
    required this.artID,
  });

  @override
  State<PaintingRootPage> createState() => _PaintingRootPageState();
}

class _PaintingRootPageState extends State<PaintingRootPage> {
  bool isAdLoaded = false;
  bool isLoading = false;
  File? _imageFile;
  ResetPasswordProvider colorChangeProvider = ResetPasswordProvider();
  // add my art
  Future<void> uploadNetworkImage2() async {
    print(isLoading);
    setState(() {
      isLoading = true;
    });
    print(isLoading);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail').toString();
    String myToken = prefs.getString('getaccesToken').toString();

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://cv.glamouride.org/api/upload-art'),
      );

      // Add headers, including the access token
      request.headers['Authorization'] = 'Bearer $myToken';

      request.fields['email'] = userEmail;
      request.fields['art_id'] = widget.artID;
      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile!.path),
      );

      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        String message = 'Image uploaded successfully';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.whiteColor,
            content: Text(
              message,
              style: TextStyle(
                color: ColorConstant.buttonColor2,
              ),
            ),
          ),
        );
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to upload image. Status code: ${response.statusCode}');
        String message = 'Failed to upload image. Status code';
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: ColorConstant.whiteColor,
            content: Text(
              message,
              style: TextStyle(
                color: ColorConstant.buttonColor2,
              ),
            ),
          ),
        );
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error Reasone is:: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.whiteColor,
          content: Text(
            'Failed to upload : $e',
            style: TextStyle(
              color: ColorConstant.buttonColor2,
            ),
          ),
        ),
      );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBannerAdd();
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
                    const Text(''),
                    // GestureDetector(
                    //   onTap: () {
                    //     uploadNetworkImage2();
                    //   },
                    //   child: isLoading
                    //       ? SizedBox(
                    //           height: 40,
                    //           width: 40,
                    //           child: CircularProgressIndicator(
                    //             color: ColorConstant.whiteColor,
                    //           ))
                    //       : Image.asset(
                    //           'assets/images/contest.jpg',
                    //           height: 40,
                    //           width: 40,
                    //         ),
                    // ),
                  ],
                ),
              ),

              // image
              Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorConstant.buttonColor2,
                ),
                child: InteractiveViewer(
                  child: WorldMap(widget.mArt,widget.artID),
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
