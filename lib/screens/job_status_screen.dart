import 'package:flutter/material.dart';
import 'package:waiwan_senior/model/job.dart';
import 'package:waiwan_senior/screens/chat.dart';
import 'package:waiwan_senior/screens/job_completed_screen.dart';
import 'package:waiwan_senior/utils/font_size_helper.dart';
import 'package:waiwan_senior/utils/format_time.dart';

class JobStatusScreen extends StatefulWidget {
  final MyJob job;

  const JobStatusScreen({super.key, required this.job});

  @override
  State<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends State<JobStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: Text(
          'สถานะงาน',
          style: FontSizeHelper.createTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // สถานะงาน
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้อรอผู้จ้างชำระเงิน
                  Text(
                    'อยู่ในช่วงการดำเนินงาน',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Steps
                  _buildProgressSteps(),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // ข้อมูลผู้จ้าง
                  Text(
                    'ผู้จ้าง',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.job.userDisplayName,
                            style: FontSizeHelper.createTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'เบอร์โทร: 0945741297',
                            style: FontSizeHelper.createTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  if (widget.job.status == 'in_progress')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // ปุ่มยืนยัน - เด้งไปหน้าสถานะงาน
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChatScreen(
                                        chatroomId: widget.job.chatRoomId!,
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'แชท',
                              style: FontSizeHelper.createTextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // รายละเอียดงาน
                  _buildDetailRow(
                    'วันที่:',
                    start2EndDateTime(
                      widget.job.startedAt!,
                      widget.job.endedAt,
                    ).split(',')[0],
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'เวลา:',
                    start2EndDateTime(
                      widget.job.startedAt!,
                      widget.job.endedAt,
                    ).split(',')[1],
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'งานที่จ้าง',
                    widget.job.title,
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'รายละเอียด',
                    widget.job.description,
                    Colors.black,
                  ),

                  const SizedBox(height: 20),

                  // ปุ่มควบคุม
                  Row(
                    children: [
                      // ปุ่มขอความช่วยเหลือ (แดง)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'ขอความช่วยเหลือ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // ปุ่มจบงาน (เขียว)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // เด้งไปหน้า "เสร็จสิ้น"
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => JobCompletedScreen(job: widget.job),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'จบงาน',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // สถานที่ทำงาน
                  Text(
                    'สถานที่ทำงาน',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.job.location != null && widget.job.location['address'] != null
                        ? widget.job.location['address']
                        : 'ไม่มีข้อมูลที่อยู่',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: เปิดแผนที่
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เปิดแผนที่')),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.location_pin, size: 24, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          'เปิดแผนที่',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step 1 - User (สีเขียว - active)
          _buildStep(Icons.person, true, true),
          _buildConnector(true),

          // Step 2 - Coin (สีเขียว - active)
          _buildStep(Icons.monetization_on, true, true),
          _buildConnector(true),

          // Step 3 - Person at computer (สีเขียว - active)
          _buildStep(Icons.computer, true, true),
          _buildConnector(false),

          // Step 4 - Check (เทา - inactive)
          _buildStep(Icons.check, false, false),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, bool isActive, bool isCompleted) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color:
            isActive || isCompleted
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: isActive || isCompleted ? Colors.white : Colors.grey[600],
        size: 28,
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Container(
      width: 30,
      height: 2,
      color:
          isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: FontSizeHelper.createTextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: FontSizeHelper.createTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
