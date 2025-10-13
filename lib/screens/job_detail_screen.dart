import 'package:flutter/material.dart';
import 'package:waiwan/screens/chat.dart';
import 'package:waiwan/utils/font_size_helper.dart';
import 'package:waiwan/screens/job_status_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, String> jobData;

  const JobDetailScreen({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: Text(
          'รายละเอียดงาน',
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
            // หัวข้อรายละเอียด
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Text(
                    'รายละเอียด',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ผู้จ้าง
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'ผู้จ้าง',
                          style: FontSizeHelper.createTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jobData['employerName'] ?? 'นายกาย',
                            style: FontSizeHelper.createTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'เบอร์โทร: 0945741297',
                            style: FontSizeHelper.createTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  if (jobData['status'] == 'accepted')
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
                                      (context) =>
                                          ChatScreen(chatroomId: jobData['chatRoomId']!,),
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

                  // วันที่และเวลา
                  _buildDetailRow(
                    'วันที่:',
                    jobData['date']?.split(',')[0] ?? '20/02/2568',
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'เวลา:',
                    jobData['date']?.split(', ')[1] ?? '09:00-14:00',
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'งานที่จ้าง',
                    jobData['jobType'] ?? 'ทำงาน',
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 20),

                  // รายละเอียดงาน
                  Text(
                    'รายละเอียดงาน',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    jobData['jobType'] ?? 'ทำงาน',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ราคาที่จ้าง
                  _buildDetailRow(
                    'ราคาที่จ้าง',
                    jobData['salary'] ?? '฿ 0.00/คน',
                    Theme.of(context).colorScheme.primary,
                    isPrice: true,
                  ),
                  const SizedBox(height: 20),

                  // เส้นคั่น
                  const Divider(),
                  const SizedBox(height: 20),

                  // สถานที่ทำงาน
                  Text(
                    'สถานที่ทำงาน',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '88/1 ลลองกรง 1 แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ปุ่มตอบรับ
            if (jobData['applicationStatus'] == "pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // ปุ่มไม่สนใจ - กลับไปหน้า job_screen และไปที่ tab ยกเลิก/ปฏิเสธ
                        Navigator.pop(context, 4); // ส่ง index 3 กลับไป
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ไม่สนใจ',
                        style: FontSizeHelper.createTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // ปุ่มยืนยัน - เด้งไปหน้าสถานะงาน
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => JobStatusScreen(jobData: jobData),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'ยืนยัน',
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color valueColor, {
    bool isPrice = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: FontSizeHelper.createTextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: FontSizeHelper.createTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
