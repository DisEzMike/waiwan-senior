import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waiwan/screens/startapp/ability_info.dart';
//import 'package:waiwan/screens/main_screen.dart';
import 'package:waiwan/screens/startapp/start_screen.dart';
import 'package:waiwan/screens/startapp/phone_input_screen.dart';
import 'package:waiwan/screens/startapp/otp_screen.dart';
import 'package:waiwan/screens/startapp/idcard_scan_screen.dart';
import 'package:waiwan/screens/startapp/personal_info_screen.dart';
import 'package:waiwan/screens/startapp/face_scan.dart';
import 'package:waiwan/screens/startapp/ability_info.dart';
import 'package:waiwan/screens/startapp/cash_income.dart';
import 'package:waiwan/utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waiwan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: myPrimaryColor,
          primary: myPrimaryColor,
          secondary: mySecondaryColor,
          surface: myBackgroundColor,
        ),
        primaryTextTheme: TextTheme(
          bodyLarge: TextStyle(color: myTextColor),
          bodyMedium: TextStyle(color: myTextColor),
          bodySmall: TextStyle(color: myTextColor),
        ),
        textTheme: GoogleFonts.kanitTextTheme(
          Theme.of(
            context,
          ).textTheme.apply(bodyColor: myTextColor, displayColor: myTextColor),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: myTextButtonColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: const StartScreen(),
      routes: {
        //'/review': (context) => const ReviewScreen(),
        '/phone': (context) => PhoneInputScreen(),
        '/otp': (context) => const OtpScreen(),
        '/idcard': (context) => const IdCardScanScreen(),
        '/face': (context) => const FaceScanScreen(),
        '/personal_info': (context) => const PersonalInfoScreen(),
        '/ability_info': (context) => const AbilityInfoScreen(),
        '/cash_income' : (context) => const CashIncomeScreen()

      },
    );
  }
}
