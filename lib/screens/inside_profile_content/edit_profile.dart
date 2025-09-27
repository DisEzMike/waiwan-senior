import 'package:flutter/material.dart';
import 'package:waiwan/screens/inside_profile_content/blankpage.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FEE7),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(110, 183, 21, 1.0), // opacity ต้อง 0–1
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 24),
          child: Column(
            children: [
              // โปรไฟล์การ์ด
              ProfileCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BlankPage(title: 'แก้ไขข้อมูลส่วนตัว'),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ===== แถวข้อมูลพร้อมค่า (ด้านขวา) =====
              MenuTile(
                title: 'ชื่อ',
                value: 'นายบาบี้ ที่หนึ่งเท่านั้น',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlankPage(title: 'ชื่อ')),
                ),
              ),
              MenuTile(
                title: 'เบอร์โทร',
                value: '028-264-1234',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlankPage(title: 'เบอร์โทร')),
                ),
              ),
              MenuTile(
                title: 'ที่อยู่',
                value: '999/9 ฉลองกรุง 1 แขวง...',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlankPage(title: 'ที่อยู่')),
                ),
              ),
              MenuTile(
                title: 'ความสามารถ',
                value: 'พับกล่อง ทำอาหาร...',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlankPage(title: 'ความสามารถ')),
                ),
              ),
              MenuTile(
                title: 'อาชีพที่เคยทำ',
                value: 'วิศวกรรมศาสตร์...',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BlankPage(title: 'อาชีพที่เคยทำ')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// แถวเมนู + ค่าด้านขวา + เส้นคั่นล่าง
class MenuTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const MenuTile({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap ??
            () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => BlankPage(title: title)),
                ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1), // เส้นคั่นแบบในรูป
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
          child: Row(
            children: [
              // ชื่อฟิลด์ (ซ้าย)
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface.withOpacity(0.85),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ค่า (ขวา) + >
              SizedBox(
                width: width * 0.52, // ปรับพื้นที่ให้ตัดคำสวย ๆ (ลอง 0.48–0.58 ได้)
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// การ์ดโปรไฟล์ด้านบน
class ProfileCard extends StatelessWidget {
  final VoidCallback? onTap;
  const ProfileCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('แก้ไขรูปโปรไฟล์',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
