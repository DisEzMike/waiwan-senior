import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiwan_senior/model/job.dart';
import 'package:waiwan_senior/screens/chat.dart';
import 'package:waiwan_senior/utils/font_size_helper.dart';
import 'package:waiwan_senior/screens/job_status_screen.dart';
import 'package:waiwan_senior/utils/format_time.dart';

class JobDetailScreen extends StatefulWidget {
  // final Map<String, String> jobData;
  final MyJob job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  Future<void> _openGoogleMaps() async {
    final lat = widget.job.location['lat'];
    final lng = widget.job.location['lng'];

    if (lat != null && lng != null) {
      try {
        // ลองใช้ Google Maps URL ก่อน
        final googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
        );

        // ใช้ launchUrl โดยตรงโดยไม่ตรวจสอบ canLaunchUrl ก่อน
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Google Maps URL failed: $e');

        try {
          // Fallback 1: ลอง geo URI
          final geoUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
          await launchUrl(geoUrl);
        } catch (e2) {
          debugPrint('Geo URL failed: $e2');

          try {
            // Fallback 2: ลอง browser URL
            final browserUrl = Uri.parse(
              'https://maps.google.com/?q=$lat,$lng',
            );
            await launchUrl(browserUrl, mode: LaunchMode.externalApplication);
          } catch (e3) {
            debugPrint('Browser URL failed: $e3');

            // แสดง error message
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'ไม่สามารถเปิดแผนที่ได้ กรุณาตรวจสอบการติดตั้ง Google Maps',
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          }
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่พบข้อมูลตำแหน่งสถานที่'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

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
                            widget.job.userDisplayName,
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
                  if (widget.job.status == 'accepted')
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
                                        chatroomId: widget.job.chatRoomId ?? '',
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
                    widget.job.description,
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
                    '฿${widget.job.price.toStringAsFixed(2)}',
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
                    widget.job.location != null &&
                            widget.job.location['address'] != null
                        ? widget.job.location['address']
                        : 'ไม่มีข้อมูลที่อยู่',
                    style: FontSizeHelper.createTextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _openGoogleMaps(),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin, size: 24, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          'เปิดแผนที่',
                          style: FontSizeHelper.createTextStyle(
                            fontSize: 22,
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

            const SizedBox(height: 20),

            // ปุ่มตอบรับ
            if (widget.job.applicationStatus == "pending")
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
                                (context) => JobStatusScreen(job: widget.job),
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
