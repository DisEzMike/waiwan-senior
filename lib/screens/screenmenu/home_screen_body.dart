import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:waiwan/model/elderly_person.dart';
import 'package:waiwan/model/job.dart';
import 'package:waiwan/providers/font_size_provider.dart';
import 'package:waiwan/screens/screenmenu/user_main_card.dart';
import 'package:waiwan/services/job_service.dart';
import 'package:waiwan/services/user_service.dart';
import 'package:waiwan/screens/job_status_screen.dart';
import 'package:waiwan/utils/format_time.dart';
import 'package:waiwan/utils/helper.dart';
import 'package:waiwan/widgets/loading_widget.dart';
import '../../widgets/responsive_text.dart';
import '../../utils/font_size_helper.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  Timer? _timer;
  MyJob? currentJob;
  bool _isLoading = false;
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
    _setOnlineStatus();
    _timer = Timer.periodic(
      Duration(seconds: 15),
      (Timer t) => _setOnlineStatus(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfile();
  }

  @override
  void didUpdateWidget(covariant HomeScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getMyJob();
    _loadUserProfile();
  }

  void _loadUserProfile() {
    if (_isLoading) return; // Prevent multiple simultaneous loads

    setState(() {
      _isLoading = true;
    });
    UserService()
        .getProfile()
        .then((user) {
          setState(() {
            _user = user;
            _isLoading = false;
          });
        })
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
        });
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

  void _getMyJob() async {
    try {
      var job = await JobService().getMyJobs();
      if (job.isNotEmpty) {
        final ongoing = job.where((j) => j.status == 'in_progress').toList();
        final sorted =
            ongoing..sort((a, b) {
              if (a.acceptedAt == null || b.acceptedAt == null) return 0;
              return b.acceptedAt!.compareTo(a.acceptedAt!);
            });
        setState(() {
          currentJob = sorted.first;
        });
      } else {
        setState(() {
          currentJob = null;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      showErrorSnackBar(context, e.toString());
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
    return _isLoading
        ? LoadingWidget()
        : Consumer<FontSizeProvider>(
          builder: (context, fontSizeProvider, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  // กำหนดให้ทุก Widget ใน Column นี้จัดชิดซ้าย
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Existing Profile Card Container (ตอนนี้รวมทุกอย่างไว้ด้านในแล้ว) ---
                    UserMainCard(
                      user: _user,
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
          },
        );
  }

  Widget _buildJobStatusWidget() {
    // ตรวจสอบสถานะ: ถ้าถูกจ้าง (สถานะ 1) และมีข้อมูลงาน
    if (currentJob != null && currentJob!.status == 'in_progress') {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
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
            // เด้งไปหน้าสถานะงาน
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobStatusScreen(job: currentJob!),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'สถานะงานปัจจุบัน',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bag icon on left
                    Image.asset(
                      'assets/icons/bag_green.png',
                      width: FontSizeHelper.getScaledFontSize(72),
                      height: FontSizeHelper.getScaledFontSize(72),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: ResponsiveText(
                                  'วันที่',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Flexible(
                                child: ResponsiveText(
                                  start2EndDateTime(
                                    currentJob!.startedAt!,
                                    currentJob!.endedAt,
                                  ),
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: FontSizeHelper.getScaledFontSize(6)),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Flexible(
                          //       child: ResponsiveText(
                          //         'เวลา',
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.w700,
                          //       ),
                          //     ),
                          //     Flexible(
                          //       child: ResponsiveText(
                          //         '09:00 - 14:00',
                          //         fontSize: 16,
                          //         color: Colors.grey[700],
                          //         fontWeight: FontWeight.w600,
                          //         textAlign: TextAlign.end,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: FontSizeHelper.getScaledFontSize(6)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: ResponsiveText(
                                  'ผู้จ้าง',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Flexible(
                                child: ResponsiveText(
                                  currentJob!.userDisplayName,
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: FontSizeHelper.getScaledFontSize(12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: ResponsiveText(
                                  currentJob!.title,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(56, 139, 18, 1),
                                ),
                              ),
                              Flexible(
                                child: ResponsiveText(
                                  '฿${currentJob!.price.toStringAsFixed(2)}',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(56, 139, 18, 1),
                                  textAlign: TextAlign.end,
                                ),
                              ),
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
          color: Colors.white, // ใช้สีขาวแทนสีเขียว
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
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/icons/Jobber.png'),
                  width: 40,
                  height: 40,
                ),
                SizedBox(width: 10),
                Flexible(
                  child: ResponsiveText(
                    'ตอนนี้ยังไม่มีงานนะครับ',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
