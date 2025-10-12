import 'package:flutter/material.dart';
import 'package:waiwan/screens/job_completed_screen.dart';

class JobStatusScreen extends StatefulWidget {
  final Map<String, dynamic> jobData;

  const JobStatusScreen({
    super.key,
    required this.jobData,
  });

  @override
  State<JobStatusScreen> createState() => _JobStatusScreenState();
}

class _JobStatusScreenState extends State<JobStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        title: const Text(
          'สถานะงาน',
          style: TextStyle(
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
                    style: TextStyle(
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
                    style: TextStyle(
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
                        child: Icon(Icons.person, color: Colors.grey[600], size: 32),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.jobData['employerName'] ?? 'นายกาย',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'เบอร์โทร: 0945741297',
                            style: TextStyle(
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
                    widget.jobData['date']?.split(',')[0] ?? '20/02/2568',
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'เวลา:',
                    widget.jobData['date']?.split(', ')[1] ?? '09:00-14:00',
                    Colors.black,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'งานที่จ้าง',
                    widget.jobData['jobType'] ?? 'จัดสถานที่',
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'รายละเอียด',
                    widget.jobData['jobType'] ?? 'จัดสถานที่',
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
                                builder: (context) => JobCompletedScreen(
                                  jobData: widget.jobData,
                                ),
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '88/1 ลลองกรง 1 แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร 10520',
                    style: TextStyle(
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
                        Icon(
                          Icons.location_pin,
                          size: 24,
                          color: Colors.blue,
                        ),
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
        color: isActive || isCompleted 
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
      color: isActive 
          ? Theme.of(context).colorScheme.primary 
          : Colors.grey[300],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}