import 'dart:convert';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:colorvelvetus/Screens/ContestArtView.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContestPage extends StatefulWidget {
  String contestID = '';
  ContestPage({
    super.key,
    required this.contestID,
  });

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
  bool isLoading = false;
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
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse(
        'https://cv.glamouride.org/api/contest-arts/${widget.contestID}');

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
            isLoading = false;
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
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getContests();
    getUserData();
    print(widget.contestID.toString());
  }

  //

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          backgroundColor: data.isEmpty ? ColorConstant.whiteColor : null,
          body: userID == ''
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    data.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: MediaQuery.of(context).size.height * 1.00,
                            width: MediaQuery.of(context).size.width * 1.00,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/images/background.png'),
                              alignment: Alignment.topRight,
                            )),
                          ),
                    data.isEmpty
                        ? const SizedBox()
                        : Container(
                            height: MediaQuery.of(context).size.height * 1.00,
                            width: MediaQuery.of(context).size.width * 1.00,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                              image:
                                  AssetImage('assets/images/background2.png'),
                              alignment: Alignment.bottomLeft,
                            )),
                          ),
                    data.isEmpty
                        ? const SizedBox()
                        : Container(
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
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorConstant.blackColor,
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
                          Row(
                            children: [
                              Text(
                                'Contest: ',
                                style: GoogleFonts.eduTasBeginner(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.buttonColor2,
                                ),
                              ),
                              Text(
                                widget.contestID,
                                style: GoogleFonts.lato(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w500,
                                  color: ColorConstant.buttonColor2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          isLoading
                              ? Expanded(
                                  child: Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstant.buttonColor2,
                                  ),
                                ))
                              : data.isEmpty
                                  ? LottieBuilder.asset(
                                      'assets/lottie/noDataFound.json')
                                  : Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: data.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContestArtView(
                                                    artImage: data[index]
                                                        ['user_art_image'],
                                                    profileImage: data[index]
                                                        ['user_profile_image'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CardWidget(
                                              width: double.infinity,
                                              cardColor: ColorConstant
                                                  .buttonColor2
                                                  .withOpacity(0.20),
                                              height: 150.0,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 150,
                                                    width: screenWidth * 0.40,
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: ColorConstant
                                                              .buttonColor2),
                                                    ),
                                                    child: Container(
                                                      height: 130,
                                                      width: screenWidth * 0.40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        image: DecorationImage(
                                                          image: NetworkImage(data[
                                                                  index][
                                                              'user_art_image']),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 150,
                                                    width: screenWidth * 0.50,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: ColorConstant
                                                          .whiteColor,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Which on is the Winner for you?',
                                                          style: GoogleFonts
                                                              .playfairDisplay(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              data[index]['winner'] ==
                                                                      0
                                                                  ? Text(
                                                                      'Winner is Pending',
                                                                      style: GoogleFonts
                                                                          .playfairDisplay(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                        color: ColorConstant
                                                                            .buttonColor2,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      data[index]
                                                                          [
                                                                          'winner'],
                                                                      style: GoogleFonts
                                                                          .playfairDisplay(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                        color: ColorConstant
                                                                            .buttonColor2,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .blue),
                                                                  shape: BoxShape
                                                                      .circle),
                                                              child: data[index]
                                                                          [
                                                                          'user_profile_image'] !=
                                                                      ''
                                                                  ? CircleAvatar(
                                                                      radius:
                                                                          18,
                                                                      backgroundImage:
                                                                          NetworkImage(data[index]
                                                                              [
                                                                              'user_profile_image']),
                                                                    )
                                                                  : null,
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
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





// Container(
//                                 margin: const EdgeInsets.only(bottom: 16),
//                                 height: 380,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: ColorConstant.whiteColor,
//                                   border: Border.all(
//                                     color: ColorConstant.buttonColor2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: ColorConstant.buttonColor,
//                                       blurRadius: 6.0,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       margin: const EdgeInsets.only(top: 12),
//                                       height: 200,
//                                       width: double.infinity,
//                                       decoration: BoxDecoration(
//                                         border: Border(
//                                           bottom: BorderSide(
//                                             color: ColorConstant.greyColor
//                                                 .withOpacity(0.20),
//                                           ),
//                                         ),
//                                       ),
//                                       child: data[index]['user_art_image'] ==
//                                               null
//                                           ? Text(
//                                               'No Image',
//                                               style: GoogleFonts.lato(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.w400,
//                                                 color:
//                                                     ColorConstant.buttonColor2,
//                                                 letterSpacing: 1.0,
//                                               ),
//                                             )
//                                           : Image.network(
//                                               data[index]['user_art_image'],
//                                               // fit: BoxFit.cover,
//                                             ),
//                                     ),
//                                     // profile image
//                                     Positioned(
//                                       top: 175,
//                                       left: screenWidth * 0.36,
                                      // child: Container(
                                      //   decoration: BoxDecoration(
                                      //       border:
                                      //           Border.all(color: Colors.blue),
                                      //       shape: BoxShape.circle),
                                      //   child: userImage != null
                                      //       ? CircleAvatar(
                                      //           radius: 36,
                                      //           backgroundImage: NetworkImage(
                                      //               data[index]
                                      //                   ['user_profile_image']),
                                      //         )
                                      //       : const CircleAvatar(
                                      //           radius: 36,
                                      //           backgroundImage: AssetImage(
                                      //               'assets/images/noImage.png'),
                                      //         ),
                                      // ),
//                                     ),
//                                     Container(
//                                       padding: const EdgeInsets.only(
//                                           left: 12, bottom: 12),
//                                       height: 380,
//                                       width: double.infinity,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         children: [
//                                           Text(
//                                             'Contest ID: ${data[index]['contest_id']}',
//                                             style: GoogleFonts.lato(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500,
//                                               color: ColorConstant.buttonColor2,
//                                               letterSpacing: 0.7,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 6),
//                                           Text(
//                                             'Contest Name: ${data[index]['contest_name'].toUpperCase()}',
//                                             style: GoogleFonts.eduTasBeginner(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500,
//                                               color: ColorConstant.buttonColor2,
//                                               letterSpacing: 0.7,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 6),
//                                           Text(
//                                             'Uploaded by: ${data[index]['user_name'].toUpperCase()}',
//                                             style: GoogleFonts.eduTasBeginner(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.w500,
//                                               color: ColorConstant.buttonColor2,
//                                               letterSpacing: 0.7,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 6),
//                                           data[index]['winner'] == 0
//                                               ? Text(
//                                                   'Winner: Decision Pending',
//                                                   style: GoogleFonts
//                                                       .eduTasBeginner(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: ColorConstant
//                                                         .buttonColor2,
//                                                     letterSpacing: 0.7,
//                                                   ),
//                                                 )
//                                               : Text(
//                                                   'Winner: ${data[index]['winner']}',
//                                                   style: GoogleFonts
//                                                       .eduTasBeginner(
//                                                     fontSize: 16,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: ColorConstant
//                                                         .buttonColor2,
//                                                     letterSpacing: 0.7,
//                                                   ),
//                                                 ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );