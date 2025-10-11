import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:waiwan/services/user_service.dart';
import 'Status/Employment_data.dart';
import 'Status/JobStatus.dart';
// history removed
import 'data/demo_data.dart';
import 'data/elderlypersonclass.dart';
import '../../widgets/responsive_text.dart';
import '../../utils/font_size_helper.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  Timer? _timer;
  final EmployeeData employee =
      mockHiredEmployee; // เปลี่ยนเป็น mockNotHiredEmployee เพื่อทดสอบสถานะ notHired
  final ElderlyPerson elderlyPerson = demoElderlyPersons.firstWhere(
    (person) => person.id == 1,
  );

  @override
  void initState() {
    super.initState();
    _setOnlineStatus();
    _timer = Timer.periodic(
      Duration(seconds: 15),
      (Timer t) => _setOnlineStatus(),
    );
  }

  void _setOnlineStatus() async {
    try {
      debugPrint("Setting user online status...");
      Position position = await _determinePosition();
      await UserService().setOnline(
        position.latitude,
        position.longitude,
      ); // เรียกใช้ครั้งแรกทันที
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          // กำหนดให้ทุก Widget ใน Column นี้จัดชิดซ้าย
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Existing Profile Card Container (ตอนนี้รวมทุกอย่างไว้ด้านในแล้ว) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                // เพิ่ม Padding 20.0 ภายใน Container
                padding: const EdgeInsets.all(20.0),
                // *** เปลี่ยนจาก Row เป็น Column เพื่อจัดเรียงเนื้อหาในแนวตั้ง ***
                child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                  // compute caps relative to available width to avoid overflow
                  final maxWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
                      ? constraints.maxWidth
                      : MediaQuery.of(context).size.width;

                  final avatarSize = math.min(
                      FontSizeHelper.getScaledFontSize(110), maxWidth * 0.28);
                  final smallIconSize = math.min(
                      FontSizeHelper.getScaledFontSize(40), maxWidth * 0.12);

                  final greetingFont = math.min(FontSizeHelper.getScaledFontSize(20), maxWidth * 0.06);
                  final nameFont = math.min(FontSizeHelper.getScaledFontSize(24), maxWidth * 0.08);
                  final labelFont = math.min(FontSizeHelper.getScaledFontSize(16), maxWidth * 0.05);

                  return Column(
                      children: [
                    // 1. ส่วนเดิม: รูปภาพและรายละเอียด (ยังคงใช้ Row จัดเรียงแนวนอน)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Profile Image ---
                        Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              elderlyPerson.imageUrl,
                              width: avatarSize,
                              height: avatarSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ), // ตัวเว้นระยะห่างระหว่างรูปกับข้อความ
                        // --- Text Details ---
                        Expanded(
                          // ใช้ Expanded เพื่อให้ Text Column ใช้พื้นที่ที่เหลือ
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveText(
                                'สวัสดีตอนเช้า !!!',
                                fontSize: greetingFont,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(125, 125, 125, 1),
                              ),

                              ResponsiveText(
                                elderlyPerson.name,
                                fontSize: nameFont,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(56, 139, 18, 1),
                              ),
                              SizedBox(height: FontSizeHelper.getScaledFontSize(4)),
                              ResponsiveText(
                                'SKILLS',
                                fontSize: labelFont,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(125, 125, 125, 1),
                              ),
                              ResponsiveText(
                                elderlyPerson.ability,
                                fontSize: labelFont,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(125, 125, 125, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ), // ปิด Row ส่วนโปรไฟล์เดิม
                    // 2. ตัวเว้นระยะห่างระหว่างส่วนบนกับส่วนล่าง
                    const SizedBox(height: 5),

                    // 3. ส่วนใหม่: กรอบสีเขียวและข้อความเพิ่มเติม (อยู่ใน Container หลัก)
                    Container(
                      // ไม่ต้องมี margin เพราะอยู่ใน Padding ของ Container หลักอยู่แล้ว
                      padding: const EdgeInsets.all(
                        10.0,
                      ), // เพิ่มระยะห่างภายในกรอบ

                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/cash.png',
                                width: smallIconSize,
                                height: smallIconSize,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveText(
                                    '500.00',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  ResponsiveText(
                                    'รายได้วันนี้',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(125, 125, 125, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 40), // ระยะห่างระหว่างสอง Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/tip.png',
                                width: smallIconSize,
                                height: smallIconSize,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveText(
                                    '50',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(78, 127, 233, 1),
                                  ),
                                  ResponsiveText(
                                    'ทิปวันนี้',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(125, 125, 125, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 0),
                    Container(
                      // ไม่ต้องมี margin เพราะอยู่ใน Padding ของ Container หลักอยู่แล้ว
                      padding: const EdgeInsets.all(
                        10.0,
                      ), // เพิ่มระยะห่างภายในกรอบ

                      child: Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/star.png',
                                width: smallIconSize,
                                height: smallIconSize,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ResponsiveText(
                                    '4.60',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(242, 179, 64, 1),
                                  ),
                                  ResponsiveText(
                                    'คะแนนรีวิว',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromRGBO(125, 125, 125, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ), // ระยะห่างระหว่างสอง Container
                  ],
                ); // ปิด Column ที่เป็น child ของ Padding
              },
              ),
            ),
            ), // ปิด Container หลัก (กรอบโปรไฟล์)
            const SizedBox(height: 20),
            _buildJobStatusWidget(),
            const SizedBox(height: 20),
            // history box removed
            // Add your widgets here (ตอนนี้ส่วนข้อความใหม่ถูกย้ายเข้าไปด้านในแล้ว)
          ],
        ),
      ),
    );
  }

  Widget _buildJobStatusWidget() {
    // ตรวจสอบสถานะ: ถ้าถูกจ้าง (สถานะ 1) และมีข้อมูลงาน
  if (employee.status == EmploymentStatus.isHired &&
    employee.currentJob != null) {
      // ----------------------------------------------------
      // A. สถานะ: ถูกจ้าง (แสดงกรอบงานปัจจุบันสีเขียว)
      // ----------------------------------------------------
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            print('Go to current job details: ${employee.currentJob!.jobTitle}');
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'สถานะงานปัจจุบัน',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: FontSizeHelper.getScaledFontSize(8)),
                ResponsiveText(
                  'อยู่ในช่วงดำเนินงาน',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
                SizedBox(height: FontSizeHelper.getScaledFontSize(14)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bag icon on left
                    Image.asset(
                      'assets/icons/bag_green.png',
                      width: FontSizeHelper.getScaledFontSize(72),
                      height: FontSizeHelper.getScaledFontSize(72),
                    ),
                    SizedBox(width: FontSizeHelper.getScaledFontSize(12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText('วันที่', fontSize: 16, fontWeight: FontWeight.w700),
                              ResponsiveText('20/02/2568', fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w600),
                            ],
                          ),
                          SizedBox(height: FontSizeHelper.getScaledFontSize(6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText('เวลา', fontSize: 16, fontWeight: FontWeight.w700),
                              ResponsiveText('09:00 - 14:00', fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w600),
                            ],
                          ),
                          SizedBox(height: FontSizeHelper.getScaledFontSize(6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText('ผู้จ้าง', fontSize: 16, fontWeight: FontWeight.w700),
                              ResponsiveText('${employee.currentJob!.employerName}', fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w600),
                            ],
                          ),
                          SizedBox(height: FontSizeHelper.getScaledFontSize(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ResponsiveText('จัดสถานที่', fontSize: 15, fontWeight: FontWeight.w700, color: Color.fromRGBO(56, 139, 18, 1)),
                              ResponsiveText('${employee.currentJob!.paymentAmount.toStringAsFixed(2)}฿ ', fontSize: 15, fontWeight: FontWeight.w700, color: Color.fromRGBO(56, 139, 18, 1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // ----------------------------------------------------
      // B. สถานะ: ไม่ได้ถูกจ้าง (แสดงปุ่ม 'ดำเนินการต่อ' ทั่วไป) (สถานะ 0)
      // ----------------------------------------------------
      // ... (ใน else block ของ _buildJobStatusWidget)
      return Container(
        // **1. กำหนดขนาดและตกแต่ง Container**
        width: double.infinity, // กว้างเต็มที่
        height: 80, // สูง 80 ตามที่คุณต้องการ
        margin: const EdgeInsets.symmetric(horizontal: 5), // เผื่อระยะห่างขอบ
        decoration: BoxDecoration(
          color:
              Theme.of(
                context,
              ).colorScheme.secondary, // ใช้สีพื้นหลังเดียวกับปุ่ม
          borderRadius: BorderRadius.circular(
            10,
          ), // อาจเพิ่มมุมโค้งมนเพื่อให้ดูคล้ายปุ่ม
          // สามารถเพิ่ม Shadow ได้หากต้องการ
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        // **2. ใช้ InkWell ครอบเพื่อให้ตอบสนองการแตะ**
        child: InkWell(
          onTap: () {
            print('Go to find new job or start application');
          },
          // กำหนดขอบเขตของการแตะตามขอบของ Container
          borderRadius: BorderRadius.circular(10),

          // **3. เนื้อหาของปุ่ม (Text)**
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/icons/Jobber.png'),
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Text(
                  'ตอนนี้ยังไม่มีงานนะครับ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  // ...โค้ดเดิมใน _HomeScreenBodyState...

  // History UI removed

  // ...โค้ดเดิมใน _HomeScreenBodyState...
}
