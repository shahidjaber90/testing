import 'package:colorvelvetus/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:colorvelvetus/Providers/LoginProvider.dart';
import 'package:colorvelvetus/Providers/LogoutProvider.dart';
import 'package:colorvelvetus/Providers/PaymentProvider.dart';
import 'package:colorvelvetus/Providers/PlanMonthlyProvider.dart';
import 'package:colorvelvetus/Providers/ResetPassword.dart';
import 'package:colorvelvetus/Providers/SignUpProvider.dart';
import 'package:colorvelvetus/Providers/updateprovider.dart';
import 'package:colorvelvetus/Screens/SplashView.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  var devices = ["C67F444F370EA0C67E323A96AFEE418F"];
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration =
      RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  Stripe.publishableKey =
      "pk_test_51Nze4zBoWpCWkiM4z8tQcjzbJ2Xc6Thg0Kkz3cd0QLYXWF0KO2zlY8beV42cr7bbLsHXZ29mevM4WtIVcRKTjpKq00BXzCVnFa";
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => ResetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => PlanMonthlyProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => LogOutProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}


