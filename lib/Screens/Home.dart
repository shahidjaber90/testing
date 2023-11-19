import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:colorvelvetus/Screens/PaintingWork/Painting_root.dart';
import 'package:colorvelvetus/Screens/Payment_Plans/ChooseYourPlan.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:colorvelvetus/LocalData/LocalData.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int currentIndex = 0;
  int activeIndex = 0;
  bool isLoading = false;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> cateData = [];
  String cateIndex = '1';
  final myItems = [
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/image-1.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/image-2.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/image-3.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    ),
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(
            'assets/images/image-4.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    ),
  ];
  // set variable to store image
  File? _imageFile;
  // download image to url
  Future<void> _downloadImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Check if the request was successful
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      ui.Codec codec = await ui.instantiateImageCodec(bytes);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      _imageFile = await _saveImage(frameInfo.image);
      setState(() {}); // Trigger a rebuild to display the image
    } else {
      throw Exception('Failed to load image');
    }
  }

// save image to _imageFile  variable
  Future<File> _saveImage(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData!.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }

  // upload image 2
  Future<void> uploadNetworkImage2(String artID) async {
    setState(() {
      isLoad = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail').toString();
    String myToken = prefs.getString('getaccesToken').toString();
    print('userEmail: $userEmail');
    print('artID: $artID');
    print('artID: $_imageFile');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://cv.glamouride.org/api/upload-art'),
      );

      // Add headers, including the access token
      request.headers['Authorization'] = 'Bearer $myToken';

      request.fields['email'] = userEmail;
      request.fields['art_id'] = artID;
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
          isLoad = false;
        });
      } else {
        setState(() {
          isLoad = false;
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
        isLoad = false;
      });
      print('Error Reasone is:: $e');
    }
  }

  Future<List<dynamic>> getArt() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse(
        'https://cv.glamouride.org/api/get-arts-by-category/$cateIndex');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
      // 'Authorization': 'Bearer 56|KlifdgZ3686pwfB3wwIsfkaEeaZBsbAf3g2vhdhx89312d7a',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final datas = jsonDecode(response.body);
        if (datas['result'] == true) {
          print('data : ${datas['arts']['data'][0]["name"]}');
          List<Map<String, dynamic>> result =
              List<Map<String, dynamic>>.from(datas['arts']['data']);

          setState(() {
            data = result;
            isLoading = false;
          });
        }
        return datas['arts']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        data.clear();
        isLoading = false;
      });
      throw Exception('Errorrrrrrrrrrrrr: $e');
    }
  }

  //

  Future<List<dynamic>> category() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/categories');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final datas = jsonDecode(response.body);
        if (datas['result'] == true) {
          print('data : ${datas['categories']['data'][0]["name"]}');
          List<Map<String, dynamic>> result =
              List<Map<String, dynamic>>.from(datas['categories']['data']);
          setState(() {
            cateData = result;
          });
        }
        return datas['categories']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  bool isWaiting = false;
  bool isLoad = false;
  bool isFav = false;
  void loading() async {
    setState(() {
      isWaiting = true;
    });
    await Future.delayed(
      const Duration(seconds: 3),
    );
    setState(() {
      isWaiting = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArt();
    category();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    final Swidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: isWaiting
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.buttonColor2,
                ),
              ),
            )
          : Scaffold(
              body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1.00,
                  width: double.infinity,
                  child: isLoading
                      ? const SizedBox()
                      : Image.asset('assets/images/sTop.png'),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  height: MediaQuery.of(context).size.height * 1.00,
                  width: double.infinity,
                  child: isLoading
                      ? const SizedBox()
                      : Image.asset(
                          'assets/images/dLeft.png',
                          height: 200,
                          width: 200,
                        ),
                ),
                // main data
                Container(
                  height: MediaQuery.of(context).size.height * 1.00,
                  width: double.infinity,
                  color: ColorConstant.whiteColor,
                  child: Column(
                    children: [
                      // App Bar
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          gradient: LinearGradient(colors: [
                            ColorConstant.buttonColor2,
                            ColorConstant.buttonColor,
                          ]),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Home',
                                    style: GoogleFonts.eduTasBeginner(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstant.whiteColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ChooseYourPlan(),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/images/payment.png',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    // second
                                    GestureDetector(
                                        onTap: () async {
                                          LogOutProvider logoutProvider =
                                              LogOutProvider();
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          // ignore: use_build_context_synchronously
                                          await logoutProvider
                                              .logoutFunction(context)
                                              .then((value) => prefs
                                                  .remove('getaccesToken'));
                                          final GoogleSignIn googleSignIn =
                                              GoogleSignIn();
                                          await googleSignIn.signOut();
                                          await FirebaseAuth.instance.signOut();
                                          print('logout successfully');
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         const SettingsView(),
                                          //   ),
                                          // );
                                        },
                                        child: Icon(
                                          Icons.logout_outlined,
                                          color: ColorConstant.whiteColor,
                                          size: 30,
                                        )),
                                  ],
                                )
                              ],
                            ),

                            // Carousel Slider
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.145,
                                autoPlayCurve: Curves.decelerate,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 500),
                                autoPlayInterval: const Duration(seconds: 2),
                                aspectRatio: 4,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                              ),
                              items: myItems,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: myItems.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 12,
                                dotColor: Colors.grey.shade800,
                                activeDotColor: Colors.grey.shade200,
                                paintStyle: PaintingStyle.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Filter View
                      Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: cateData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeIndex = index;
                                  cateIndex = (index + 1).toString();
                                  print(cateData[index]['name']);
                                  print('index: $cateIndex');
                                  getArt();
                                });
                              },
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 6),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  gradient: activeIndex == index
                                      ? LinearGradient(colors: [
                                          ColorConstant.buttonColor2,
                                          ColorConstant.buttonColor,
                                        ])
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MyText(
                                  myText: cateData[index]['name'],
                                  fontSize: 16.0,
                                  fontweight: activeIndex == index
                                      ? FontWeight.w500
                                      : FontWeight.w500,
                                  textColor: activeIndex == index
                                      ? ColorConstant.whiteColor
                                      : ColorConstant.buttonColor2,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      //
                      isLoading
                          ? Expanded(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: ColorConstant.buttonColor2,
                                )),
                              ),
                            )
                          : data.isEmpty
                              ? Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    child: Center(
                                      child: LottieBuilder.asset(
                                        'assets/lottie/noDataFound.json',
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 10)
                                        .copyWith(top: 10),
                                    child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: (550 / Swidth * 0.40),
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        bool isSvgImage(String url) {
                                          return url
                                              .toLowerCase()
                                              .endsWith('.svg');
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            double width = double.parse(
                                                data[index]['width']);
                                            double height = double.parse(
                                                data[index]['width']);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaintingRootPage(
                                                  mArt: data[index],
                                                  artID: data[index]['id']
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              data[index]['image_path'] ==
                                                          null ||
                                                      data[index]['image_path']
                                                              [0]['path'] ==
                                                          null
                                                  ? const SizedBox()
                                                  : Container(
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: ColorConstant
                                                            .whiteColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: ColorConstant
                                                                .greyColor,
                                                            blurRadius: 6.0,
                                                          ),
                                                        ],
                                                      ),
                                                      child: isSvgImage(
                                                              data[index]
                                                                  ['image'])
                                                          ? SvgPicture.network(
                                                              data[index]
                                                                  ['image'],
                                                              // fit: BoxFit.cover,
                                                            )
                                                          : Image.network(
                                                              data[index]
                                                                  ['image'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
              ],
            )),
    );
  }
}

// void modalBottomSheet(context) {
//   showModalBottomSheet(
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.70,
//           width: MediaQuery.of(context).size.width * 1.00,
//           color: ColorConstant.backgroundColor,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   MyText(
//                     myText: 'Category Order',
//                     fontweight: FontWeight.w400,
//                     textColor: ColorConstant.whiteColor,
//                     fontSize: 30.0,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: 24,
//                       width: MediaQuery.of(context).size.width * 0.10,
//                       child: Icon(
//                         Icons.arrow_drop_up_sharp,
//                         color: ColorConstant.whiteColor,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               MyText(
//                 myText:
//                     'Tap to jump to the category and drag to change the order',
//                 fontweight: FontWeight.w400,
//                 textColor: ColorConstant.whiteColor,
//                 fontSize: 16.0,
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               GridView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: (36 / 15),
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: categoryData.length,
//                 cacheExtent: 30.0,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     alignment: Alignment.bottomCenter,
//                     decoration: BoxDecoration(
//                       color: const Color(0XFF540459),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: MyText(
//                       myText: categoryData[index],
//                       fontweight: FontWeight.w400,
//                       textColor: ColorConstant.whiteColor,
//                       fontSize: 18.0,
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//         );
//       });
// }
