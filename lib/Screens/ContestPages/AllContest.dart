import 'dart:convert';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:colorvelvetus/Screens/ContestArtView.dart';
import 'package:colorvelvetus/Screens/ContestPage.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllContestPage extends StatefulWidget {
  const AllContestPage({super.key});

  @override
  State<AllContestPage> createState() => _AllContestPageState();
}

class _AllContestPageState extends State<AllContestPage> {
  // get contests
  List<Map<String, dynamic>> data = [];
  Future<List<dynamic>> getAllContests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/contests');

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
              List<Map<String, dynamic>>.from(datas['contests']['data']);
          setState(() {
            data = contest;
          });
        }
        //
        final jsonData = jsonDecode(response.body);
        // final datas = jsonData['arts'];
        return jsonData['contests']['data'];
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
    getAllContests();
  }

  //

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
          padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Contests',
                    style: GoogleFonts.eduTasBeginner(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: ColorConstant.buttonColor2,
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        LogOutProvider logoutProvider = LogOutProvider();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        // ignore: use_build_context_synchronously
                        await logoutProvider
                            .logoutFunction(context)
                            .then((value) => prefs.remove('getaccesToken'));
                        final GoogleSignIn googleSignIn = GoogleSignIn();
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContestPage(
                              contestID: data[index]['id'].toString(),
                            ),
                          ),
                        );
                        print('contest id : ${data[index]['id']}');
                      },
                      child: Container(
                        height: 240,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data[index]['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.playfairDisplay(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: ColorConstant.buttonColor2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CardWidget(
                              width: double.infinity,
                              cardColor:
                                  ColorConstant.buttonColor2.withOpacity(0.20),
                              height: 180.0,
                              child: Row(
                                children: [
                                  Container(
                                    height: 180,
                                    width: screenWidth * 0.40,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: ColorConstant.buttonColor2),
                                    ),
                                    child: Container(
                                      height: 150,
                                      width: screenWidth * 0.40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              data[index]['cover_image']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 180,
                                    width: screenWidth * 0.50,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: ColorConstant.whiteColor,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        data[index]['description'] == null
                                            ? Text(
                                                'Not available description',
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color:
                                                      ColorConstant.blackColor,
                                                ),
                                              )
                                            : Text(
                                                data[index]['description'],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style:
                                                    GoogleFonts.playfairDisplay(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color:
                                                      ColorConstant.blackColor,
                                                ),
                                              ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              data[index]['winner'] == null
                                                  ? Text(
                                                      'Winner is Pending',
                                                      style: GoogleFonts
                                                          .playfairDisplay(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .buttonColor2,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Winner is ${data[index]['winner']}',
                                                      style: GoogleFonts
                                                          .playfairDisplay(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .buttonColor2,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: ColorConstant.buttonColor2,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Go to Contest',
                                            style: GoogleFonts.playfairDisplay(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstant.whiteColor,
                                            ),
                                          ),
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
                    );
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
