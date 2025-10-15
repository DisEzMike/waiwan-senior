import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waiwan_senior/model/job.dart';
import 'package:waiwan_senior/utils/font_size_helper.dart';
import 'package:waiwan_senior/utils/format_time.dart';

class JobCompletedScreen extends StatefulWidget {
  final MyJob job;

  const JobCompletedScreen({super.key, required this.job});

  @override
  State<JobCompletedScreen> createState() => _JobCompletedScreenState();
}

class _JobCompletedScreenState extends State<JobCompletedScreen> {
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
            // Container หลัก
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
                  // หัวข้อ "เสร็จสิ้น"
                  Text(
                    'เสร็จสิ้น',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Steps (ครบทั้ง 4 steps)
                  _buildCompletedProgressSteps(context),

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

                  // ปุ่ม "เสร็จสิ้น" สีเขียว
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // กลับไปหน้าหลัก
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'เสร็จสิ้น',
                        style: FontSizeHelper.createTextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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
                  const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedProgressSteps(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step 1 - User (สีเขียว - completed)
          _buildStep(Icons.person, true, true, context),
          _buildConnector(true, context),

          // Step 2 - Coin (สีเขียว - completed)
          _buildStep(Icons.monetization_on, true, true, context),
          _buildConnector(true, context),

          // Step 3 - Computer (สีเขียว - completed)
          _buildStep(Icons.computer, true, true, context),
          _buildConnector(true, context),

          // Step 4 - Check (สีเขียว - completed)
          _buildStep(Icons.check, true, true, context),
        ],
      ),
    );
  }

  Widget _buildStep(
    IconData icon,
    bool isActive,
    bool isCompleted,
    BuildContext context,
  ) {
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

  Widget _buildConnector(bool isActive, BuildContext context) {
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
