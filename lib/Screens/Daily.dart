import 'dart:convert';
import 'package:colorvelvetus/Screens/ContestPage.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:colorvelvetus/Utils/LocalVariables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  late List<Contest> contests;
  bool isLoading = false;

  void loading() async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(
      const Duration(seconds: 3),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContests();
    loading();
  }

  Future<void> _fetchContests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    final Uri url = Uri.parse('https://cv.glamouride.org/api/contests');

    final Map<String, String> headers = {
      'Authorization': 'Bearer $myToken',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> contestsData = data['contests']['data'];

      setState(() {
        contests =
            contestsData.map((contest) => Contest.fromJson(contest)).toList();
        contests.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } else {
      throw Exception('Failed to load contests');
    }
  }

  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: isLoading
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
                  contests == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: contests.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Display the heading
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 30),
                                  child: Text(
                                    'Daily',
                                    style: GoogleFonts.eduTasBeginner(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w500,
                                      color: ColorConstant.buttonColor2,
                                    ),
                                  ),
                                ),
                              );
                            }

                            // Display contest data
                            Contest contest = contests[index - 1];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContestPage(
                                      contestID: contest.id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 190,
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatDate(contest.createdAt),
                                      style: GoogleFonts.aBeeZee(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: ColorConstant.buttonColor2,
                                      ),
                                    ),
                                    CardWidget(
                                      width: double.infinity,
                                      cardColor: ColorConstant.buttonColor2
                                          .withOpacity(0.20),
                                      height: 150.0,
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 150,
                                            width: screenWidth * 0.40,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: ColorConstant
                                                      .buttonColor2),
                                            ),
                                            child: Container(
                                              height: 130,
                                              width: screenWidth * 0.40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      contest.coverImage),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 150,
                                            width: screenWidth * 0.50,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: ColorConstant.whiteColor,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Which on is the Winner for you?',
                                                  style: GoogleFonts
                                                      .playfairDisplay(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant
                                                        .buttonColor2,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    'Go to Contest',
                                                    style: GoogleFonts
                                                        .playfairDisplay(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: ColorConstant
                                                          .whiteColor,
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
                ],
              ),
            ),
    );
  }
}
