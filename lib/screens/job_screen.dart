import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiwan/providers/font_size_provider.dart';
import 'package:waiwan/screens/job_detail_screen.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex =
      0; // 0 = คำขอจ้างงาน, 1 = กำลังดำเนินงาน, 2 = ประวัติการจ้าง, 3 = ยกเลิก/ปฏิเสธ

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return Column(
          children: [
            // ปุ่มแท็บใต้ Top App Bar
            _buildTabButtons(fontProvider),
            // เนื้อหาตามแท็บที่เลือก
            Expanded(child: _buildTabContent(fontProvider)),
          ],
        );
      },
    );
  }

  Widget _buildTabButtons(FontSizeProvider fontProvider) {
    final tabs = [
      'คำขอจ้างงาน',
      'กำลังดำเนินงาน',
      'ประวัติการจ้าง',
      'ยกเลิก/ปฏิเสธ',
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      height: fontProvider.getScaledFontSize(50), // Make height responsive
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // เลื่อนแนวนอน
        child: Row(
          children:
              tabs.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    right:
                        index < tabs.length - 1
                            ? 8.0
                            : 0, // เว้นระยะระหว่างปุ่ม
                  ),
                  child: _buildTabButton(index, title, fontProvider),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    int index,
    String title,
    FontSizeProvider fontProvider,
  ) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: fontProvider.getScaledFontSize(12),
          horizontal: fontProvider.getScaledFontSize(20),
        ),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontProvider.getScaledFontSize(14),
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(FontSizeProvider fontProvider) {
    switch (_selectedIndex) {
      case 0:
        return _buildJobRequestsContent(fontProvider);
      case 1:
        return _buildOngoingJobsContent();
      case 2:
        return _buildJobHistoryContent();
      case 3:
        return _buildCancelledJobsContent();
      default:
        return _buildJobRequestsContent(fontProvider);
    }
  }

  Widget _buildJobRequestsContent(FontSizeProvider fontProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildJobCard(
            date: '20/02/2568, 09:00 - 14:00',
            employerName: 'น้องกาย',
            jobType: 'ทำอาหาร',
            salary: '500.00',
          ),
          const SizedBox(height: 9),
          _buildJobCard(
            date: '22/02/2568, 10:00 - 16:00',
            employerName: 'คุณหญิง',
            jobType: 'จัดเตรียมของ',
            salary: '600.00',
          ),
          const SizedBox(height: 9),
          _buildJobCard(
            date: '25/02/2568, 08:00 - 12:00',
            employerName: 'นายไมค์',
            jobType: 'ล้างจาน',
            salary: '350.00',
          ),
          // Add some bottom padding to ensure last card is fully visible
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String date,
    required String employerName,
    required String jobType,
    required String salary,
  }) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return GestureDetector(
          onTap: () async {
            debugPrint('Card tapped: $jobType'); // Debug print
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => JobDetailScreen(
                      jobData: {
                        'date': date,
                        'employerName': employerName,
                        'jobType': jobType,
                        'salary': salary,
                      },
                    ),
              ),
            );

            // ถ้ากดปุ่ม "ไม่สนใจ" จะได้ result = 3
            if (result == 3) {
              setState(() {
                _selectedIndex = 3; // เปลี่ยนไปที่ tab ยกเลิก/ปฏิเสธ
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // ไอคอนกระเป๋าสีเขียว
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // ข้อมูลงาน
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // วันที่และเวลา
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: fontProvider.getScaledFontSize(14),
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          jobType,
                          style: TextStyle(
                            fontSize: fontProvider.getScaledFontSize(14),
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // ตำแหน่งงาน
                        Row(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Text(
                                'ผู้จ้าง',
                                style: TextStyle(
                                  fontSize: fontProvider.getScaledFontSize(14),
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              flex: 3,
                              child: Text(
                                employerName,
                                style: TextStyle(
                                  fontSize: fontProvider.getScaledFontSize(16),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        // ค่าจ้าง
                        const SizedBox(width: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                '$salary บาท',
                                style: TextStyle(
                                  fontSize: fontProvider.getScaledFontSize(16),
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildOngoingJobsContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.work_outline,
                size: fontProvider.getScaledFontSize(64),
                color: Colors.grey,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(16)),
              Text(
                'กำลังดำเนินงาน',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(18),
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(8)),
              Text(
                'ยังไม่มีงานที่กำลังดำเนินการ',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(14),
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJobHistoryContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: fontProvider.getScaledFontSize(64),
                color: Colors.grey,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(16)),
              Text(
                'ประวัติการจ้าง',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(18),
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(8)),
              Text(
                'ยังไม่มีประวัติการจ้างงาน',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(14),
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCancelledJobsContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel_outlined,
                size: fontProvider.getScaledFontSize(64),
                color: Colors.grey,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(16)),
              Text(
                'ยกเลิก / ปฏิเสธ',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(18),
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(8)),
              Text(
                'ยังไม่มีงานที่ยกเลิกหรือปฏิเสธ',
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(14),
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
