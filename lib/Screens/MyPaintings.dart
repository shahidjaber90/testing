import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:colorvelvetus/LocalData/LocalData.dart';
import 'package:colorvelvetus/Screens/Settings.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class UserProfiles extends StatefulWidget {
  const UserProfiles({super.key});

  @override
  State<UserProfiles> createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  int activeIndex = 0;
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
      'assets/images/image-3.jpg',
      fit: BoxFit.cover,
    ),
    Image.asset(
      'assets/images/image-4.jpg',
      fit: BoxFit.cover,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: CustomScrollView(
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        slivers: [
          SliverAppBar(
            backgroundColor: ColorConstant.backgroundColor,
            title: // App Bar
                Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MyText(
                      myText: 'Home',
                      textColor: ColorConstant.whiteColor,
                      fontSize: 36.0,
                      fontweight: FontWeight.w500,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.settings,
                            color: ColorConstant.whiteColor,
                            size: 30,
                          )),
                    ],
                  )
                ],
              ),
            ),
            expandedHeight: 230,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: const EdgeInsets.only(top: 50),
                height: 180,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        height: 160,
                        autoPlayCurve: Curves.easeInOut,
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
            ),
          ),
          // items
          SliverToBoxAdapter(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              activeIndex = index;
                              print(activeIndex);
                            });
                          },
                          child: Container(
                            height: 24,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ).copyWith(top: 2),
                            decoration: BoxDecoration(
                              color: index == activeIndex
                                  ? ColorConstant.purpleColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: MyText(
                              myText: categoryData[index],
                              fontSize: 20.0,
                              fontweight: activeIndex == index
                                  ? FontWeight.w500
                                  : FontWeight.w400,
                              textColor: ColorConstant.whiteColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      modalBottomSheet(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 24,
                      width: MediaQuery.of(context).size.width * 0.10,
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: ColorConstant.whiteColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.50,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
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
