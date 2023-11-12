import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/SignUpProvider.dart';
import 'package:colorvelvetus/Screens/LogInView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Consumer<RegisterProvider>(
      builder: (context, value, child) => Form(
        key: formKey,
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
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/leftStar.png',
                    ),
                    Image.asset(
                      'assets/images/rightStar.png',
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: Height * 0.14),
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                              myText: 'Create account',
                              fontweight: FontWeight.w700,
                              textColor: ColorConstant.blackColor,
                              fontSize: 24.0,
                            ),
                            //
                            GestureDetector(
                              onTap: () {
                                showModelBottomSheet(
                                    context,
                                    value.pickImageCamera,
                                    value.pickImageGallery);

                                Future.delayed(Duration(seconds: 5), () {
                                  Navigator.pop(context);
                                });
                              },
                              child: value.imageFile == null
                                  ? SizedBox(
                                      child: MyText(
                                        myText: 'Select Image',
                                        fontweight: FontWeight.w400,
                                        textColor: ColorConstant.buttonColor2,
                                        fontSize: 15.0,
                                      ),
                                    )
                                  : Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(36),
                                        border: Border.all(
                                          color: ColorConstant.buttonColor2,
                                        ),
                                        image: DecorationImage(
                                            image: FileImage(value.imageFile!),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 36,
                      ),
                      TextFieldWidget(
                        title: 'Username',
                        hintText: 'Your username',
                        controller: username,
                        isObscure: false,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'enter username';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFieldWidget(
                        title: 'Email',
                        hintText: 'Your email',
                        controller: email,
                        isObscure: false,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'This field is required';
                          } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(p0)) {
                            return "Please enter a valid email address";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFieldWidget(
                        title: 'Phone',
                        hintText: 'Your phone number',
                        controller: phone,
                        isObscure: false,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'This field is required';
                          } else if (phone.text.length < 11) {
                            return "Please enter a valid phone number";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFieldWidget(
                        title: 'Password',
                        hintText: 'Enter Password',
                        controller: password,
                        suffixIcon: IconButton(
                          onPressed: value.isObscureText,
                          icon: value.isObscure
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color:
                                      ColorConstant.greyColor.withOpacity(0.50),
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: ColorConstant.greyColor,
                                ),
                        ),
                        isObscure: value.isObscure,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'enter password';
                          } else if (p0.length < 6) {
                            return 'Password must be 6 character';
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFieldWidget(
                        title: 'Confirm Password',
                        hintText: 'Enter confirm password',
                        controller: confirmPassword,
                        suffixIcon: IconButton(
                          onPressed: value.isObscureText2,
                          icon: value.isObscure2
                              ? Icon(
                                  Icons.visibility_off_outlined,
                                  color:
                                      ColorConstant.greyColor.withOpacity(0.50),
                                )
                              : Icon(
                                  Icons.visibility_outlined,
                                  color: ColorConstant.greyColor,
                                ),
                        ),
                        isObscure: value.isObscure2,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return 'enter password';
                          } else if (p0.length < 6) {
                            return 'Password must be 6 character';
                          } else if (password.text != confirmPassword.text) {
                            return "Password does not match";
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 22,
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    ColorConstant.buttonColor2,
                                    ColorConstant.buttonColor,
                                  ],
                                )),
                            child: Checkbox(
                              activeColor: Colors.transparent,
                              side: BorderSide.none,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(99))),
                              value: value.isCheck,
                              onChanged: (values) {
                                value.isChecked(values);
                              },
                            ),
                          ),
                          MyText(
                            myText: 'I accept the terms and privacy policy',
                            fontweight: FontWeight.w400,
                            textColor: ColorConstant.blackColor,
                            fontSize: 12.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      value.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'assets/lottie/loading.json',
                                  height: 60,
                                  width: 80,
                                ),
                              ],
                            )
                          : ButtonWidget(
                              buttonText: 'Sign Up',
                              onTap: () {
                                if (formKey.currentState!.validate() &&
                                    value.imageFile != null) {
                                  value.register(
                                      username.text,
                                      email.text,
                                      phone.text,
                                      password.text,
                                      confirmPassword.text,
                                      context);
                                } else if (value.imageFile == null) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: MyText(
                                            myText: 'Please Select Image',
                                            fontweight: FontWeight.w500,
                                            textColor:
                                                ColorConstant.buttonColor2,
                                            fontSize: 16.0,
                                          ),
                                          actions: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: ColorConstant.blackColor,
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  return null;
                                }
                              },
                              gradient: LinearGradient(colors: [
                                ColorConstant.buttonColor2,
                                ColorConstant.buttonColor2.withOpacity(0.90),
                                ColorConstant.buttonColor,
                              ]),
                            ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          MyText(
                            myText: 'Or Sign Up with',
                            fontweight: FontWeight.w400,
                            textColor:
                                ColorConstant.blackColor.withOpacity(0.30),
                            fontSize: 15.0,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SocialButton(
                          //   width: MediaQuery.of(context).size.width * 0.28,
                          //   imageText: 'facebook',
                          //   onTap: () {},
                          // ),
                          SocialButton(
                            width: MediaQuery.of(context).size.width * 0.88,
                            imageText: 'google',
                            onTap: () {},
                          ),
                          // SocialButton(
                          //   width: MediaQuery.of(context).size.width * 0.28,
                          //   imageText: 'apple',
                          //   onTap: () {},
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                              color: ColorConstant.blackColor.withOpacity(0.30),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogInView(),
                                ),
                              );
                            },
                            child: Text(
                              'Log in',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                color: ColorConstant.blackColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

showModelBottomSheet(context, void Function()? onTap, void Function()? onTap2) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: LinearGradient(colors: [
            ColorConstant.buttonColor2.withOpacity(0.70),
            ColorConstant.buttonColor.withOpacity(0.70),
          ]),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/lottie/camera.json',
                    height: 40,
                    width: 40,
                  ),
                  MyText(
                    myText: 'Take Photo',
                    fontweight: FontWeight.w400,
                    textColor: ColorConstant.blackColor,
                    fontSize: 16.0,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTap2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LottieBuilder.asset(
                    'assets/lottie/gallery.json',
                    height: 40,
                    width: 40,
                  ),
                  MyText(
                    myText: 'Choose from Gallery',
                    fontweight: FontWeight.w400,
                    textColor: ColorConstant.blackColor,
                    fontSize: 16.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
