import 'package:flutter/material.dart';

class JobCompletedScreen extends StatelessWidget {
  final Map<String, dynamic> jobData;

  const JobCompletedScreen({
    super.key,
    required this.jobData,
  });

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
                            jobData['employerName'] ?? 'นายกาย',
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
                    jobData['jobType'] ?? 'จัดสถานที่',
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    'รายละเอียด',
                    jobData['jobType'] ?? 'จัดสถานที่',
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
                        style: TextStyle(
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '88/1 ลลองกรง 1 แขวงลาดกระบัง เขตลาดกระบัง กรุงเทพมหานคร 10520',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
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

  Widget _buildStep(IconData icon, bool isActive, bool isCompleted, BuildContext context) {
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

  Widget _buildConnector(bool isActive, BuildContext context) {
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
            fontSize: 18,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}