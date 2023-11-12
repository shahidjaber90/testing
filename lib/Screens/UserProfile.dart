import 'dart:convert';
import 'dart:io';
import 'package:colorvelvetus/Screens/SignUpView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:colorvelvetus/Providers/updateprovider.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final UpdateProvider updateProvider = UpdateProvider();
  final TextEditingController update = TextEditingController();
  bool isLoading = false;
  File? imageFile;
  String imageName = '';
  String? contentType;

  getImageType() {
    if (imageFile!.path.toLowerCase().endsWith('.jpeg')) {
      setState(() {
        contentType = 'image/jpeg';
      });
    } else if (imageFile!.path.toLowerCase().endsWith('.jpg')) {
      setState(() {
        contentType = 'image/jpg';
      });
    }
  }

  Future<void> updateImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    print(myToken);
    final url = Uri.parse('https://cv.glamouride.org/api/update-profile');
    var request = http.MultipartRequest("POST", url);

    // Set the 'Authorization' header with your token
    request.headers['Authorization'] = 'Bearer $myToken';

    request.files.add(
      http.MultipartFile(
        'profile_pic',
        imageFile!.readAsBytes().asStream(),
        imageFile!.lengthSync(),
        filename: imageName,
        contentType: MediaType.parse(contentType!),
        // MediaType(
        //   'image',
        //   'jpg',
        // ),
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      print('Profile Picture Update Successfully');

      print('API response: ${response.stream}');
    }
  }

  Future<void> updateInfo() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myToken = prefs.getString('getaccesToken').toString();
    print(myToken);
    final url = Uri.parse('https://cv.glamouride.org/api/update-profile');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myToken',
    };

    final body = jsonEncode({
      'phone': update.text,
    });

    final response = await http.post(url, headers: headers, body: body);

    var result = jsonDecode(response.body);
    String message = result['message'];
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorConstant.buttonColor2,
          content: Text(
            message,
            style: TextStyle(
              color: ColorConstant.whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
      Navigator.pop(context);

      print('API response: ${response.body}');
      print('error message ${result["errors"][0]}');
    } else {
      setState(() {
        isLoading = false;
      });
      // ignore: avoid_print
      print('response data $message');

      String error = result["errors"][0];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            error,
            style: TextStyle(color: ColorConstant.whiteColor),
          ),
        ),
      );
    }
  }

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
        print(jsonData['user']);
        return jsonData['user'];
      } else {
        throw Exception(
            'API call failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> pickImageGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        imageName = image.name;
      });
    }
    getImageType();
    await updateImage();
  }

  Future<void> pickImageCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
        imageName = image.name;
      });
    }
    getImageType();
    await updateImage();
  }

  @override
  Widget build(BuildContext context) {
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

        // data databe
        FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LottieBuilder.asset(
                  'assets/lottie/loading.json',
                  height: 100,
                  width: 140,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.hasData) {
                Map<String, dynamic> userData =
                    snapshot.data as Map<String, dynamic>;
                List seq = ['img', 'name', 'email', 'phone'];
                List seqData = [
                  {
                    'icon': Icon(
                      Icons.person_2_outlined,
                      color: ColorConstant.buttonColor2,
                    ),
                    'img': userData['profile_pic'],
                  },
                  {
                    'icon': Icon(
                      Icons.person_2_outlined,
                      color: ColorConstant.buttonColor2,
                    ),
                    'name': userData['name'],
                  },
                  {
                    'icon': Icon(
                      Icons.email_outlined,
                      color: ColorConstant.buttonColor2,
                    ),
                    'email': userData['email'],
                  },
                  {
                    'icon': Icon(
                      Icons.phone_android_outlined,
                      color: ColorConstant.buttonColor2,
                    ),
                    'phone': userData['phone'],
                  },
                ];
                // Display user data in your UI
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              ColorConstant.buttonColor2.withOpacity(0.70),
                              ColorConstant.buttonColor.withOpacity(0.70),
                            ])),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userData['profile_pic'],
                                  scale: 1),
                            )),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              print('object');
                              showModelBottomSheet(
                                  context, pickImageCamera, pickImageGallery);

                              Future.delayed(Duration(seconds: 5), () {
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.28,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: [
                                    ColorConstant.buttonColor2
                                        .withOpacity(0.70),
                                    ColorConstant.buttonColor.withOpacity(0.70),
                                  ])),
                              child: Icon(
                                Icons.camera_alt,
                                color: ColorConstant.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            userData['phone'] == null ? 3 : seqData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: index == 0
                                ? Text('')
                                : Container(
                                    height: 80,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            seqData[index]['icon'],
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            MyText(
                                              myText: seqData[index]
                                                  [seq[index]],
                                              fontweight: FontWeight.w500,
                                              textColor: ColorConstant
                                                  .blackColor
                                                  .withOpacity(0.90),
                                              fontSize: MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      361
                                                  ? 15.0
                                                  : 18.0,
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  update.text = seqData[index]
                                                      [seq[index]];
                                                  return AlertDialog(
                                                    // backgroundColor: Colors.transparent,
                                                    content: index == 3
                                                        ? Container(
                                                            height: 180,
                                                            width:
                                                                double.infinity,
                                                            color: ColorConstant
                                                                .whiteColor,
                                                            child: Column(
                                                              children: [
                                                                TextFieldWidget(
                                                                  title:
                                                                      'Phone',
                                                                  color: ColorConstant
                                                                      .buttonColor2,
                                                                  hintText:
                                                                      'Update field',
                                                                  controller:
                                                                      update,
                                                                  isObscure:
                                                                      false,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              false;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          MyText(
                                                                        myText:
                                                                            'Cancel',
                                                                        fontweight:
                                                                            FontWeight.w400,
                                                                        textColor:
                                                                            ColorConstant.blackColor,
                                                                        fontSize:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                                    isLoading
                                                                        ? StatefulBuilder(
                                                                            builder:
                                                                                (context, setState) {
                                                                              return LottieBuilder.asset(
                                                                                'assets/lottie/loading.json',
                                                                                height: 40,
                                                                                width: 60,
                                                                              );
                                                                            },
                                                                          )
                                                                        : TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              updateInfo();
                                                                            },
                                                                            child:
                                                                                MyText(
                                                                              myText: 'Update',
                                                                              fontweight: FontWeight.w400,
                                                                              textColor: ColorConstant.buttonColor2,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : MyText(
                                                            myText:
                                                                "This value Can't Change",
                                                            fontweight:
                                                                FontWeight.w400,
                                                            textColor:
                                                                ColorConstant
                                                                    .buttonColor2,
                                                            fontSize: 16.0,
                                                          ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: index == 3
                                                  ? Colors.blue.shade800
                                                  : ColorConstant.buttonColor2,
                                            ))
                                      ],
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return Text('No user data available.');
              }
            }
          },
        )
      ],
    ));
  }
}
