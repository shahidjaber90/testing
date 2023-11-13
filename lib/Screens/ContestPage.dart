import 'dart:convert';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContestPage extends StatefulWidget {
  const ContestPage({super.key});

  @override
  State<ContestPage> createState() => _ContestPageState();
}

class _ContestPageState extends State<ContestPage> {
  String title = '';
  String prize = '';
  String userID = '';
  String userName = '';
  String userImage = '';
  String startDate = '';
  String endDate = '';
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
          userName = jsonData['user']['name'];
          userImage = jsonData['user']['profile_pic'];
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
  List<Map<String, dynamic>> data = [];
  Future<List<dynamic>> getContests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    // final Uri url = Uri.parse('https://cv.glamouride.org/api/contest/1');
    final Uri url = Uri.parse('https://cv.glamouride.org/api/contest-arts/1');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        //
        // example
        Map<String, dynamic> datas = json.decode(response.body);
        if (datas['result'] == true) {
          List<Map<String, dynamic>> contest =
              List<Map<String, dynamic>>.from(datas['arts']);
          // List<Map<String, dynamic>>.from(datas['contest']['contest']);

          setState(() {
            data = contest;
          });
        }
        //
        final jsonData = jsonDecode(response.body);
        // final datas = jsonData['arts'];
        setState(() {
          title = datas['arts']['contest_name'];
          // prize = datas['arts']['prize_money'].toString();
          // startDate = jsonData['arts']['start_date'].toString();
          // endDate = jsonData['arts']['end_date'].toString();
        });
        return jsonData['arts'][0];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContests();
    getUserData();
  }

  //

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: userID == ''
            ? const Center(
                child: CircularProgressIndicator(),
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
                  Container(
                    height: screenHeight * 1.00,
                    width: screenWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 12)
                        .copyWith(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contest',
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
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 380,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorConstant.whiteColor,
                                  border: Border.all(
                                    color: ColorConstant.buttonColor2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorConstant.buttonColor,
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 12),
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: ColorConstant.greyColor
                                                .withOpacity(0.20),
                                          ),
                                        ),
                                      ),
                                      child: data[index]['user_art_image'] ==
                                              null
                                          ? Text(
                                              'No Image',
                                              style: GoogleFonts.lato(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color:
                                                    ColorConstant.buttonColor2,
                                                letterSpacing: 1.0,
                                              ),
                                            )
                                          : Image.network(
                                              data[index]['user_art_image'],
                                              // fit: BoxFit.cover,
                                            ),
                                    ),
                                    // profile image
                                    Positioned(
                                      top: 175,
                                      left: screenWidth * 0.36,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.blue),
                                            shape: BoxShape.circle),
                                        child: userImage != null
                                            ? CircleAvatar(
                                                radius: 36,
                                                backgroundImage: NetworkImage(
                                                    data[index]
                                                        ['user_profile_image']),
                                              )
                                            : const CircleAvatar(
                                                radius: 36,
                                                backgroundImage: AssetImage(
                                                    'assets/images/noImage.png'),
                                              ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 12, bottom: 12),
                                      height: 380,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Contest ID: ${data[index]['contest_id']}',
                                            style: GoogleFonts.lato(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.buttonColor2,
                                              letterSpacing: 0.7,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Contest Name: ${data[index]['contest_name'].toUpperCase()}',
                                            style: GoogleFonts.eduTasBeginner(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.buttonColor2,
                                              letterSpacing: 0.7,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Uploaded by: ${data[index]['user_name'].toUpperCase()}',
                                            style: GoogleFonts.eduTasBeginner(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.buttonColor2,
                                              letterSpacing: 0.7,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          data[index]['winner'] == 0
                                              ? Text(
                                                  'Winner: Decision Pending',
                                                  style: GoogleFonts
                                                      .eduTasBeginner(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant
                                                        .buttonColor2,
                                                    letterSpacing: 0.7,
                                                  ),
                                                )
                                              : Text(
                                                  'Winner: ${data[index]['winner']}',
                                                  style: GoogleFonts
                                                      .eduTasBeginner(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: ColorConstant
                                                        .buttonColor2,
                                                    letterSpacing: 0.7,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              // Container(
                              //   margin: const EdgeInsets.only(bottom: 10),
                              //   width: screenWidth * 0.90,
                              //   height: 325,
                              //   decoration: BoxDecoration(
                              //       color: ColorConstant.blackColor
                              //           .withOpacity(0.50),
                              //       borderRadius: BorderRadius.circular(12),
                              //       border: Border.all(
                              //           color: ColorConstant.buttonColor2)),
                              //   child: Column(
                              //     children: [
                              //       Container(
                              //         width: screenWidth * 0.90,
                              //         height: 200,
                              //         alignment: Alignment.center,
                              //         margin: const EdgeInsets.only(top: 6),
                              //         padding: const EdgeInsets.all(5.0),
                              //         decoration: BoxDecoration(
                              //             color: ColorConstant.whiteColor,
                              //             borderRadius:
                              //                 BorderRadius.circular(12),
                              //             border: Border.all(
                              //               color: Colors.blue,
                              //             )),
                              //         child: data[index]['user_art_image'] ==
                              //                 null
                              //             ? Text(
                              //                 'No Image',
                              //                 style: GoogleFonts.lato(
                              //                   fontSize: 18,
                              //                   fontWeight: FontWeight.w400,
                              //                   color:
                              //                       ColorConstant.buttonColor2,
                              //                   letterSpacing: 1.0,
                              //                 ),
                              //               )
                              //             : Stack(
                              //                 alignment: Alignment.center,
                              //                 children: [
                              //                   Image.network(
                              //                     data[index]['user_art_image'],
                              //                     fit: BoxFit.cover,
                              //                   ),
                              //                   // data
                              //                   Container(
                              //                     height: 200,
                              //                     alignment:
                              //                         Alignment.bottomRight,
                              //                     child: Column(
                              //                       children: [
                              // userImage != null
                              //     ? CircleAvatar(
                              //         radius: 24,
                              //         backgroundImage:
                              //             NetworkImage(
                              //                 userImage),
                              //       )
                              //     : const CircleAvatar(
                              //         radius: 24,
                              //         backgroundImage:
                              //             AssetImage(
                              //                 'assets/images/noImage.png'),
                              //       ),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ],
                              //               ),
                              //       ),
                              //       Container(
                              //         padding: const EdgeInsets.symmetric(
                              //             horizontal: 16),
                              //         height: 110,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceEvenly,
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   'Contest ID: ',
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.buttonColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //                 Text(
                              //                   data[index]['contest_id']
                              //                       .toString(),
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.whiteColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   'Art ID: ',
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.buttonColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //                 Text(
                              //                   data[index]['art_id']
                              //                       .toString(),
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.whiteColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   'Start Date: ',
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.buttonColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //                 Text(
                              //                   startDate.toString(),
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.whiteColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             Row(
                              //               children: [
                              //                 Text(
                              //                   'End Date: ',
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.buttonColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //                 Text(
                              //                   endDate.toString(),
                              //                   style: GoogleFonts.lato(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color:
                              //                         ColorConstant.whiteColor,
                              //                     letterSpacing: 0.6,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
