import 'package:flutter/material.dart';
import 'package:waiwan_senior/screens/chat_rooms_screen.dart';
import 'package:waiwan_senior/screens/screenmenu/home_screen_body.dart';
import 'package:waiwan_senior/screens/job_screen.dart';
import 'nav_bar.dart';
import 'profilescreen/contractor_profile.dart';
// Make sure the class name in contractor_profile.dart matches 'ContractorProfilePage'

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {

  @override
  Widget build(BuildContext context) {
    final destinations = AppDestinations.destinations;

    return NavBarWrapper(
      items: [
        AppNavItem(
          destination: destinations[0],
          builder: (context) => HomeScreenBody(),
        ),
        AppNavItem(
          destination: destinations[1],
          builder: (context) => ChatRoomsScreen(),
        ),
        AppNavItem(
          destination: destinations[2],
          builder: (context) => JobScreen(),
        ),
        AppNavItem(
          destination: destinations[3],
          builder: (context) => ContractorProfile(),
        ),
      ],
    );
  }
}
