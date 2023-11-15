import 'dart:convert';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyArt extends StatefulWidget {
  const MyArt({super.key});

  @override
  State<MyArt> createState() => _MyArtState();
}

class _MyArtState extends State<MyArt> {
  List<Map<String, dynamic>> data = [];
  String message = '';
  String artID = '';
  String userID = '';
  String contestID = '';

  Future<List<dynamic>> getMyArt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/my-arts');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> datas = json.decode(response.body);
        if (datas['result'] == true) {
          List<Map<String, dynamic>> result =
              List<Map<String, dynamic>>.from(datas['arts']['data']);
          setState(() {
            data = result;
          });
        }
        return datas['arts']['data'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // add to contest
  Future<void> addArtToContest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    String apiUrl = "https://cv.glamouride.org/api/add-to-contest";
    print('id' + artID);

    Map<String, dynamic> data = {
      'user_id': userID.toString(),
      'art_id': artID.toString(),
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
        String message = jsonData['message'];
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
        String message = 'Failed to post data';
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
        throw Exception('Failed to post data');
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  //
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyArt();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            data.isEmpty ? ColorConstant.whiteColor : Colors.transparent,
        body: data.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.buttonColor2,
                ),
              )
            : Stack(
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
                    height: MediaQuery.of(context).size.height * 1.00,
                    width: MediaQuery.of(context).size.width * 1.00,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/images/background2.png'),
                      alignment: Alignment.bottomLeft,
                    )),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 10),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12)
                        .copyWith(top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Painting',
                              style: GoogleFonts.eduTasBeginner(
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                                },
                                child: Icon(
                                  Icons.logout_outlined,
                                  color: ColorConstant.blackColor,
                                  size: 30,
                                )),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                            child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (screenWidth * 0.42 / 190),
                            // crossAxisSpacing: 10,
                            // mainAxisSpacing: 10,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorConstant.buttonColor2
                                          .withOpacity(
                                        0.40,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 150,
                                        width: screenWidth * 0.42,
                                        margin: const EdgeInsets.symmetric(
                                                horizontal: 5)
                                            .copyWith(top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  data[index]['image'],
                                                ),
                                                fit: BoxFit.cover)),
                                      ),
                                      Container(
                                        height: 40,
                                        alignment: Alignment.topCenter,
                                        width: screenWidth * 0.42,
                                        child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                userID = data[index]['user_id']
                                                    .toString();
                                                artID = data[index]['art_id']
                                                    .toString();
                                                contestID = data[index]
                                                        ['status']
                                                    .toString();
                                              });
                                              addArtToContest();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Add To Contest',
                                                  style: GoogleFonts.lato(
                                                    fontSize: screenWidth < 361
                                                        ? 12
                                                        : 16,
                                                    color: ColorConstant
                                                        .buttonColor2,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: ColorConstant
                                                      .buttonColor2,
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                // Positioned(
                                //   right: 0,
                                //   child: Container(
                                //     margin: const EdgeInsets.symmetric(
                                //         horizontal: 12, vertical: 12),
                                //     height: 32,
                                //     width: 32,
                                //     alignment: Alignment.center,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: ColorConstant.blackColor,
                                //     ),
                                //     child: GestureDetector(
                                //       onTap: () {
                                //       },
                                //       // child: _imageFile != null
                                //       //     ? Image.file(_imageFile!)
                                //       child: Icon(
                                //         Icons.add,
                                //         color: Colors.green.shade500,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                ],
              ));
  }
}
