import 'package:colorvelvetus/Providers/GoogleLogin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/LoginProvider.dart';
import 'package:colorvelvetus/Screens/ForgotPassword.dart';
import 'package:colorvelvetus/Screens/SignUpView.dart';
import 'package:colorvelvetus/Utils/Colors.dart';
import 'package:colorvelvetus/Widgets/ButtonWidget.dart';
import 'package:colorvelvetus/Widgets/MyText.dart';
import 'package:colorvelvetus/Widgets/SocialButton.dart';
import 'package:colorvelvetus/Widgets/TextFieldWidget.dart';

class LogInView extends StatefulWidget {
  const LogInView({super.key});

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Consumer<LoginProvider>(
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
                alignment: Alignment.topRight,
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/RightStar2.png',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                padding: const EdgeInsets.only(top: 60, left: 30),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/LeftStar2.png',
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ).copyWith(top: Height * 0.24),
                height: MediaQuery.of(context).size.height * 1.00,
                width: MediaQuery.of(context).size.width * 1.00,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Welcome!',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: ColorConstant.blackColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Image.asset(
                            'assets/images/hi.png',
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(99))),
                                  value: value.isCheck,
                                  onChanged: (values) {
                                    value.isChecked(values);
                                  },
                                ),
                              ),
                              MyText(
                                myText: 'Remember me',
                                fontweight: FontWeight.w400,
                                textColor: ColorConstant.blackColor,
                                fontSize: 12.0,
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPassword(),
                                ),
                              );
                            },
                            child: MyText(
                              myText: 'Forgot password?',
                              fontweight: FontWeight.w400,
                              textColor: ColorConstant.blackColor,
                              fontSize: 12.0,
                            ),
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
                              buttonText: 'Sign In',
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  value.loginAPIRequest(
                                      email.text, password.text, context);
                                } else {
                                  return null;
                                }
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const ChooseYourPlan(),
                                //   ),
                                // );
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
                            myText: 'Or Login with',
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
                            onTap: () {
                              GoogleServices().signinWithGoogle(context);
                            },
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
                            "Don't have an account?",
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
                                  builder: (context) => const SignUpView(),
                                ),
                              );
                            },
                            child: Text(
                              'SignUp',
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
