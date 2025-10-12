import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:waiwan/model/elderly_person.dart';
import 'package:waiwan/utils/font_size_helper.dart';
import 'edit_profile.dart';
import '../../widgets/user_profile/profile_header.dart';
import '../../widgets/user_profile/menu_items.dart';

class ContractorProfile extends StatefulWidget {
  final ElderlyPerson user;
  const ContractorProfile({super.key, required this.user});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  @override
  void initState() {
    super.initState();
  }

  void _logout() async {
    // Show confirmation dialog
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ออกจากระบบ',
            style: FontSizeHelper.createTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?',
            style: FontSizeHelper.createTextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).primaryTextTheme.bodyLarge?.color,
              ),
              child: Text(
                'ยกเลิก',
                style: FontSizeHelper.createTextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(
                'ออกจากระบบ',
                style: FontSizeHelper.createTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If user confirmed logout
    if (shouldLogout == true) {
      try {
        // Clear stored token
        localStorage.removeItem('token');
        localStorage.removeItem('user_data');

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ออกจากระบบเรียบร้อยแล้ว'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to login/start screen and clear navigation stack
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/', // Adjust this to your login/start route
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
        // Handle logout error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEE7),
      body: SafeArea(
        child: Column(
          children: [
            // Profile card
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2FEE7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile info section
                    ProfileHeader(
                      name: widget.user.displayName,
                      subtitle: 'แก้ไขข้อมูลส่วนตัว',
                      imageAsset: widget.user.profile.imageUrl,
                      onEditPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(user: widget.user),
                          ),
                        );
                      },
                    ),
                    // Menu Items
                    const MenuItems(),
                    const SizedBox(height: 20),

                    // Logout button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _logout,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.logout, size: 20),
                          label: Text(
                            'ออกจากระบบ',
                            style: FontSizeHelper.createTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
