import 'dart:convert';
import 'dart:io';
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
  List<Color> itemColors =
      List.generate(categoryData.length, (index) => Colors.transparent);
  int currentIndex = 0;
  final myItems = [
    Image.asset(
      'assets/images/image-1.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/image-2.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/image-3.png',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/image-4.jpg',
      fit: BoxFit.cover,
    ),
  ];
  int activeIndex = 0;

  // download image to url
  File? _imageFile;
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

  Future<File> _saveImage(ui.Image image) async {
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    List<int> pngBytes = byteData!.buffer.asUint8List();
    Directory tempDir = await getTemporaryDirectory();
    File file = File('${tempDir.path}/image.png');
    await file.writeAsBytes(pngBytes);
    return file;
  }

  // upload image
  Future<void> uploadNetworkImage(String artID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('userEmail').toString();
    final url = Uri.parse('https://cv.glamouride.org/api/upload-art');
    var request = http.MultipartRequest("POST", url);

    // // Add text fields
    request.fields['email'] = userEmail;
    request.fields['art_id'] = artID;

    request.files.add(
      http.MultipartFile(
        'profile_pic',
        _imageFile!.readAsBytes().asStream(),
        _imageFile!.lengthSync(),
        // filename: imageName,
        contentType: MediaType('image', 'jpg'),
      ),
    );

    final response = await request.send();

    var result = await response.stream.bytesToString();
    // String message = result[0];
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: ColorConstant.whiteColor,
      //     content: Text(
      //       message,
      //       style: TextStyle(color: ColorConstant.buttonColor2),
      //     ),
      //   ),
      // );

      print('API response: ${response.stream}');
    } else {
      // Request failed, handle the error
      print('Error:>>> ${response.statusCode}');
      // print('response data ${message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'SignUp Failed: This email is already exists.',
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }

  // upload image 2
  Future<void> uploadNetworkImage2(String artID) async {
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
      } else {
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
      print('Error Reasone is:: $e');
    }
  }

  //

  Future<List<dynamic>> getArt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/get-arts');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
      // 'Authorization': 'Bearer 56|KlifdgZ3686pwfB3wwIsfkaEeaZBsbAf3g2vhdhx89312d7a',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['arts']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
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
        final jsonData = jsonDecode(response.body);
        return jsonData['categories']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 1.00,
            width: double.infinity,
            child: Image.asset('assets/images/sTop.png'),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            height: MediaQuery.of(context).size.height * 1.00,
            width: double.infinity,
            child: Image.asset(
              'assets/images/dLeft.png',
              height: 200,
              width: 200,
            ),
          ),
          // main data
          SizedBox(
            height: MediaQuery.of(context).size.height * 1.00,
            width: double.infinity,
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
                                        await SharedPreferences.getInstance();
                                    // ignore: use_build_context_synchronously
                                    await logoutProvider
                                        .logoutFunction(context)
                                        .then((value) =>
                                            prefs.remove('getaccesToken'));
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
                                    color: ColorConstant.blackColor,
                                    size: 30,
                                  )),
                            ],
                          )
                        ],
                      ),

                      // Carousel Slider
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: double.infinity,
                        child: Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                height:
                                    MediaQuery.of(context).size.height * 0.16,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 700),
                                autoPlayInterval: const Duration(seconds: 2),
                                enlargeCenterPage: true,
                                aspectRatio: 2,
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
                    ],
                  ),
                ),
                // Filter View
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: FutureBuilder<List<dynamic>>(
                          future: category(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<dynamic>> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<dynamic> categorysData = snapshot.data ?? [];
                              return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: categorysData.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activeIndex = index;
                                        print(categorysData[index]['name']);
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(right: 6),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                        myText: categorysData[index]['name'],
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
                              );
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // modalBottomSheet(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 24,
                          width: MediaQuery.of(context).size.width * 0.07,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: ColorConstant.buttonColor2,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: getArt(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<dynamic> data = snapshot.data ?? [];
                        final Swidth = MediaQuery.of(context).size.width;
                        return GridView.builder(
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
                            // print('onr ${data[index]['name']}');
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaintingRootPage(
                                      mArt: data[index],
                                    ),
                                  ),
                                );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => NewCanvasPage(
                                //       coloringImage: ColoringImage(
                                //         data[index]['name'],
                                //         data[index]['image'],
                                //         data[index]['id'].toString(),
                                //       ),
                                //       // textImage:
                                //     ),
                                //   ),
                                // );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: data[index]['image_path'] == null
                                        ? Image.network(
                                            data[index]['image'],
                                            fit: BoxFit.cover,
                                          )
                                        : Text(data[index]['art_type']),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      height: 32,
                                      width: 32,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorConstant.blackColor,
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await _downloadImage(
                                              data[index]['image']);
                                          uploadNetworkImage2(
                                              data[index]['id'].toString());
                                        },
                                        child: _imageFile != null
                                            ? Image.file(_imageFile!)
                                            : Icon(
                                                Icons.add,
                                                color: Colors.green.shade500,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
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

void modalBottomSheet(context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.70,
          width: MediaQuery.of(context).size.width * 1.00,
          color: ColorConstant.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    myText: 'Category Order',
                    fontweight: FontWeight.w400,
                    textColor: ColorConstant.whiteColor,
                    fontSize: 30.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 24,
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: Icon(
                        Icons.arrow_drop_up_sharp,
                        color: ColorConstant.whiteColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              MyText(
                myText:
                    'Tap to jump to the category and drag to change the order',
                fontweight: FontWeight.w400,
                textColor: ColorConstant.whiteColor,
                fontSize: 16.0,
              ),
              const SizedBox(
                height: 10,
              ),
              GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: (36 / 15),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 10,
                ),
                itemCount: categoryData.length,
                cacheExtent: 30.0,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: const Color(0XFF540459),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: MyText(
                      myText: categoryData[index],
                      fontweight: FontWeight.w400,
                      textColor: ColorConstant.whiteColor,
                      fontSize: 18.0,
                    ),
                  );
                },
              )
            ],
          ),
        );
      });
}
