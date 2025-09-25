import 'package:flutter/material.dart';
import 'package:waiwan/components/bottom_appbar.dart'; // ใช้ประเภท Destination
import 'package:waiwan/screens/profile_content.dart'; // ใช้หน้าโปรไฟล์
import 'package:waiwan/screens/notification_content.dart';

class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key});
  final String title = 'หน้าแรก';

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;
  String _currentTitle = 'หน้าแรก';

  static const List<Destination> destinations = <Destination>[
    Destination(
      icon: Icons.home_outlined,
      iconSelected: Icons.home,
      label: 'หน้าแรก',
    ),
    Destination(
      icon: Icons.message_outlined,
      iconSelected: Icons.message,
      label: 'ข้อความ',
    ),
    Destination(
      icon: Icons.notifications_outlined,
      iconSelected: Icons.notifications,
      label: 'แจ้งเตือน',
    ),
    Destination(
      icon: Icons.person_outlined,
      iconSelected: Icons.person,
      label: 'โปรไฟล์',
    ),
  ];

  // ✅ หน้าของแต่ละแท็บ (เอา ProfileContent มาใส่แท็บโปรไฟล์)
  final List<Widget> _pages = const [
    Center(child: Text('หน้าแรก')),
    Center(child: Text('ข้อความ')),
    NotificationScreen (),
    ProfileContent(), // << หน้าต่างโปรไฟล์ของคุณ
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primary,
        title: Text(
          _currentTitle,
          style: TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),

      // ❌ เดิม: body: Scaffold(),
      // ✅ ใหม่: แสดงเพจตามแท็บ
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: NavigationBar(
        backgroundColor: scheme.primary,
        
        // ถ้าเวอร์ชันคุณฟ้อง ให้เปลี่ยนเป็น MaterialStatePropertyAll(...)
        // ignore: deprecated_member_use
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        destinations:
            destinations
                .map(
                  (d) => NavigationDestination(
                    icon: Icon(d.icon, color: scheme.onPrimary),
                    selectedIcon: Icon(d.iconSelected, color: scheme.onPrimary),
                    label: d.label,
                  ),
                )
                .toList(),
        selectedIndex: _currentIndex,
        indicatorColor: scheme.inversePrimary,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
            _currentTitle = destinations[index].label;
          });
        },
      ),
    );
  }
}
