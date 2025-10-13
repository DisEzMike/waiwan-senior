import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:waiwan/model/elderly_person.dart';
import 'package:waiwan/screens/screenmenu/home_screen_body.dart';
import 'package:waiwan/utils/font_size_helper.dart';
import 'package:waiwan/widgets/responsive_text.dart';

class UserMainCard extends StatelessWidget {
  ElderlyPerson user;
  UserMainCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        // เพิ่ม Padding 20.0 ภายใน Container
        padding: const EdgeInsets.all(20.0),
        // *** เปลี่ยนจาก Row เป็น Column เพื่อจัดเรียงเนื้อหาในแนวตั้ง ***
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // compute caps relative to available width to avoid overflow
            final maxWidth =
                constraints.maxWidth.isFinite && constraints.maxWidth > 0
                    ? constraints.maxWidth
                    : MediaQuery.of(context).size.width;

            final avatarSize = math.min(
              FontSizeHelper.getScaledFontSize(110),
              maxWidth * 0.28,
            );
            final smallIconSize = math.min(
              FontSizeHelper.getScaledFontSize(40),
              maxWidth * 0.12,
            );

            // final greetingFont = math.min(
            //   FontSizeHelper.getScaledFontSize(20),
            //   maxWidth * 0.06,
            // );
            final nameFont = math.min(
              FontSizeHelper.getScaledFontSize(24),
              maxWidth * 0.08,
            );
            final labelFont = math.min(
              FontSizeHelper.getScaledFontSize(16),
              maxWidth * 0.05,
            );

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
                        child: Image.network(
                          user.profile.imageUrl,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ResponsiveText(
                          //   'สวัสดีตอนเช้า !!!',
                          //   fontSize: greetingFont,
                          //   fontWeight: FontWeight.w700,
                          //   color: Color.fromRGBO(125, 125, 125, 1),
                          // ),
                          ResponsiveText(
                            user.displayName,
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
                            user.ability.otherAbility,
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
                const SizedBox(height: 10),

                // 3. ส่วนใหม่: สถิติแบบ 2 คอลัมน์
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // แถวแรก: รายได้และทิป
                      Row(
                        children: [
                          // รายได้วันนี้
                          Expanded(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/cash.png',
                                  width: smallIconSize,
                                  height: smallIconSize,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ResponsiveText(
                                        '500.00',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                      ResponsiveText(
                                        'รายได้วันนี้',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(125, 125, 125, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // ทิปวันนี้
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/tip.png',
                                  width: smallIconSize,
                                  height: smallIconSize,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ResponsiveText(
                                        '50',
                                        fontSize: 18,
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
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // แถวที่สอง: คะแนนรีวิว (กึ่งกลาง)
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/star.png',
                            width: smallIconSize,
                            height: smallIconSize,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ResponsiveText(
                                '4.60',
                                fontSize: 18,
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
                ),
              ],
            ); // ปิด Column ที่เป็น child ของ Padding
          },
        ),
      ),
    );
  }
}
