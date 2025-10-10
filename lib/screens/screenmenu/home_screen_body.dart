import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:waiwan/services/user_service.dart';
import 'Status/Employment_data.dart';
import 'Status/JobStatus.dart';
import 'history/history_class.dart';
import 'history/history_data.dart';
import 'data/demo_data.dart';
import 'data/elderlypersonclass.dart';

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
    print("Setting user online status...");
    Position position = await _determinePosition();
    await UserService().setOnline(
      position.latitude,
      position.longitude,
    ); // เรียกใช้ครั้งแรกทันที
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
                child: Column(
                  children: [
                    // 1. ส่วนเดิม: รูปภาพและรายละเอียด (ยังคงใช้ Row จัดเรียงแนวนอน)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Profile Image ---
                        Container(
                          width: 110,
                          height: 110,
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
                              width: 110,
                              height: 110,
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
                              Text(
                                'สวัสดีตอนเช้า !!!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(125, 125, 125, 1),
                                ),
                              ),

                              Text(
                                elderlyPerson.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(56, 139, 18, 1),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'SKILLS',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(125, 125, 125, 1),
                                ),
                              ),
                              Text(
                                elderlyPerson.ability,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(125, 125, 125, 1),
                                ),
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
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '0.00',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const Text(
                                    'รายได้วันนี้',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(125, 125, 125, 1),
                                    ),
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
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '50',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(78, 127, 233, 1),
                                    ),
                                  ),
                                  const Text(
                                    'ทิปวันนี้',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(125, 125, 125, 1),
                                    ),
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
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '4.60',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(242, 179, 64, 1),
                                    ),
                                  ),
                                  const Text(
                                    'คะแนนรีวิว',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(125, 125, 125, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ), // ระยะห่างระหว่างสอง Container
                  ],
                ), // ปิด Column ที่เป็น child ของ Padding
              ),
            ), // ปิด Container หลัก (กรอบโปรไฟล์)
            const SizedBox(height: 20),
            _buildJobStatusWidget(),
            const SizedBox(height: 20),
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
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildHistoryList(context)],
                ),
              ),
            ),
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
            print(
              'Go to current job details: ${employee.currentJob!.jobTitle}',
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'งานปัจจุบัน',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // แถวที่ 2: ชื่องาน & ค่าจ้าง
                    Row(
                      children: [
                        Text(
                          '${employee.currentJob!.jobTitle}   ', // ดึงชื่องาน
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 50),
                        Text(
                          '${employee.currentJob!.paymentAmount.toStringAsFixed(2)} บาท', // ดึงค่าจ้าง
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(56, 139, 18, 1),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    // แถวที่ 3: ผู้จ้างงาน
                    Row(
                      children: [
                        const Text(
                          'ผู้จ้างงาน',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${employee.currentJob!.employerName}', // ดึงชื่อผู้จ้างงาน
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Icon ลูกศรด้านขวา
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 26,
                  color: Color.fromRGBO(56, 139, 18, 1),
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

  // 1. ฟังก์ชันสำหรับจัดกลุ่ม HistoryItem โดยใช้เฉพาะส่วนวันที่ 'YYYY-MM-DD' เป็น Key
  Map<String, List<HistoryItem>> _groupHistoryByDate(
    List<HistoryItem> records,
  ) {
    // เรียงลำดับรายการตามวันที่จากใหม่ไปเก่า (ล่าสุดอยู่บนสุด)
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final Map<String, List<HistoryItem>> groupedHistory = {};
    for (var item in records) {
      // แยกเอาเฉพาะส่วนวันที่ (ก่อน 'T') มาเป็น Key
      final dateKey = item.date.split('T')[0];
      if (!groupedHistory.containsKey(dateKey)) {
        groupedHistory[dateKey] = [];
      }
      groupedHistory[dateKey]!.add(item);
    }
    return groupedHistory;
  }

  // 2. ฟังก์ชันสำหรับจัดรูปแบบวันที่เป็นภาษาไทย พุทธศักราช (เช่น "30 มกราคม 2554")
  String _formatDateThai(String dateKey) {
    try {
      final DateTime date = DateTime.parse(dateKey);

      // ใช้ DateFormat สำหรับรูปแบบ 'd MMMM' (วันที่ เดือน)
      final String formattedDate = DateFormat('d MMMM', 'th_TH').format(date);

      // แปลงปีคริสต์ศักราช (A.D.) เป็นปีพุทธศักราช (B.E.) โดยการบวก 543
      final int thaiYear = date.year + 543;

      return '$formattedDate $thaiYear';
    } catch (e) {
      return dateKey; // กรณีผิดพลาด ให้แสดงวันที่เดิม
    }
  }

  // 3. ฟังก์ชันสำหรับสร้าง Widget แสดงรายการประวัติทั้งหมด
  Widget _buildHistoryList(BuildContext context) {
    // จัดกลุ่มข้อมูล
    final groupedHistory = _groupHistoryByDate(historyRecords);
    final dateKeys = groupedHistory.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อ: ประวัติการจ้างงาน
        const Text(
          'ประวัติการจ้างงาน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),

        // วนลูปเพื่อแสดงข้อมูลตามวันที่
        ...dateKeys.map((dateKey) {
          final itemsForDate = groupedHistory[dateKey]!;
          final formattedDate = _formatDateThai(dateKey);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ส่วนหัว (วันที่)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(160, 115, 175, 1), // สีม่วงอ่อนตามภาพ
                  ),
                ),
              ),

              // วนลูปแสดงรายการงานในวันนั้นๆ
              ...itemsForDate.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ชื่องาน
                      Expanded(
                        child: Text(
                          item.job,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // ยอดเงิน
                      Text(
                        '+${item.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(
                            56,
                            139,
                            18,
                            1,
                          ), // สีเขียวตามภาพ
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }

  // ...โค้ดเดิมใน _HomeScreenBodyState...
}
