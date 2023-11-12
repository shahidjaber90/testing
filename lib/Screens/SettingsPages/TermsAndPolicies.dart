import 'package:flutter/material.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';

class TermAndPolicies extends StatelessWidget {
  const TermAndPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: ColorConstant.whiteColor,
        height: MediaQuery.of(context).size.height * 1.00,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: 30),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset('assets/images/backIcon.png')),
                    const Spacer(),
                    MyText(
                      myText: 'Terms and Policies',
                      fontweight: FontWeight.w600,
                      textColor: ColorConstant.blackColor,
                      fontSize: 24.0,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1.0,
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MyText(
                  myText:
                      'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus habitant morbi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa. ',
                  fontweight: FontWeight.w500,
                  textColor: ColorConstant.greyColor.withOpacity(0.40),
                  fontSize: 12.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(top: 12),
                child: MyText(
                  myText:
                      'amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus habitant morbi.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus habitant morbi.Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
                  fontweight: FontWeight.w500,
                  textColor: ColorConstant.greyColor.withOpacity(0.40),
                  fontSize: 12.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(top: 12),
                child: MyText(
                  myText:
                      'sit amet commodo magna eros quis urna. Nunc viverra imperdiet enim. Fusce est. Vivamus a tellus habitant morbi.Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Maecenas porttitor congue massa. Fusce posuere, magna sed pulvinar ultricies, purus lectus malesuada libero, sit amet commodo magna.',
                  fontweight: FontWeight.w500,
                  textColor: ColorConstant.greyColor.withOpacity(0.40),
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
