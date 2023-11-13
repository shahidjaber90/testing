import 'dart:convert';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/CardWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<Map<String, dynamic>> data = [];

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
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            // crossAxisSpacing: 10,
                            // mainAxisSpacing: 10,
                          ),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        data[index]['image'],
                                      ),
                                      fit: BoxFit.cover)),
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
