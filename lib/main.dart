import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:waiwan_senior/providers/chat_provider.dart';
import 'package:waiwan_senior/providers/font_size_provider.dart';
import 'package:waiwan_senior/screens/startapp/start_screen.dart';
import 'package:waiwan_senior/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  await initializeDateFormatting('th', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: FontSizeProvider.instance),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Waiwan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6EB715),
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
            Theme.of(context).textTheme.apply(
              bodyColor: myTextColor,
              displayColor: myTextColor,
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: myTextButtonColor,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        home: const StartScreen(),
      ),
    );
  }
}
