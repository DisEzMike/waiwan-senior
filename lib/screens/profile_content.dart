import 'package:flutter/material.dart';
import 'package:waiwan/screens/inside_profile_content/setting_content.dart';
import 'package:waiwan/screens/inside_profile_content/text_setting.dart';
import 'package:waiwan/screens/inside_profile_content/salary_setting.dart';
import 'package:waiwan/screens/inside_profile_content/Help_content.dart';
import 'package:waiwan/screens/inside_profile_content/edit_profile.dart';
import 'package:waiwan/screens/inside_profile_content/Policy_content.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView( // กันล้นและเลื่อนได้
        padding: const EdgeInsets.fromLTRB(16, 15, 16, 24),
        child: Column(
          children: [
            // ทำการ์ดโปรไฟล์ให้กดได้
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              child: const ProfileCard(),
            ),
            const SizedBox(height: 16),

            // เมนูต่างๆ (ใส่ onTap ให้แต่ละรายการ)
            MenuTile(
              title: 'การตั้งค่า',
              icon: Icons.settings,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
            ),
            MenuTile(
              title: 'การรับรายได้',
              icon: Icons.account_balance_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EarningsScreen()),
              ),
            ),
            MenuTile(
              title: 'ขนาดตัวหนังสือ',
              icon: Icons.text_fields,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TextSizeScreen()),
              ),
            ),
            MenuTile(
              title: 'ศูนย์ขอความช่วยเหลือ',
              icon: Icons.help_outline,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
              ),
            ),
            MenuTile(
              title: 'นโยบาย',
              icon: Icons.privacy_tip_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PolicyScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('นาย.....', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800)),
                  SizedBox(height: 5),
                  Text('แก้ไขข้อมูลส่วนตัว', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const MenuTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap, // ← ตรงนี้แหละ
      ),
    );
  }
}



