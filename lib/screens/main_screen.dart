import 'package:flutter/material.dart';
import 'package:waiwan/model/elderly_person.dart';
import 'package:waiwan/screens/chat_rooms_screen.dart';
import 'package:waiwan/screens/screenmenu/home_screen_body.dart';
import 'package:waiwan/screens/job_screen.dart';
import 'package:waiwan/services/user_service.dart';
import 'nav_bar.dart';
import 'profilescreen/contractor_profile.dart';
// Make sure the class name in contractor_profile.dart matches 'ContractorProfilePage'

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  ElderlyPerson _user = ElderlyPerson(
    id: "กำลังโหลด",
    displayName: "กำลังโหลด...",
    profile: SeniorProfile(
      id: "กำลังโหลด",
      firstName: "กำลังโหลด",
      lastName: "กำลังโหลด",
      idCard: "กำลังโหลด",
      iDaddress: "กำลังโหลด",
      currentAddress: "กำลังโหลด",
      chronicDiseases: "กำลังโหลด",
      contactPerson: "กำลังโหลด",
      contactPhone: "กำลังโหลด",
      phone: "กำลังโหลด",
      gender: "กำลังโหลด",
      imageUrl: 'https://placehold.co/600x400.png',
    ),
    ability: SeniorAbility(
      id: "กำลังโหลด",
      type: "กำลังโหลด",
      workExperience: "กำลังโหลด",
      otherAbility: "กำลังโหลด",
      vehicle: false,
      offsiteWork: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    UserService()
        .getProfile()
        .then((user) {
          setState(() {
            _user = user;
          });
        })
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    final destinations = AppDestinations.destinations;

    return NavBarWrapper(
      items: [
        AppNavItem(
          destination: destinations[0],
          builder: (context) => HomeScreenBody(user: _user),
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
          builder: (context) => ContractorProfile(user: _user),
        ),
      ],
    );
  }
}
