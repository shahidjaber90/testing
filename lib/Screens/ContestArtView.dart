import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:flutter/material.dart';

class ContestArtView extends StatelessWidget {
  String artImage;
  String profileImage;
  ContestArtView({
    super.key,
    required this.artImage,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
          // data
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: double.infinity,
              color: Colors.transparent,
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.network(
                artImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1.00,
            width: MediaQuery.of(context).size.width * 1.00,
            padding: const EdgeInsets.only(left: 10, top: 12, right: 10),
            alignment: Alignment.topLeft,
            child: Row(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            shape: BoxShape.circle),
                        child: profileImage != ''
                            ? CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(profileImage),
                              )
                            : const SizedBox(),),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
