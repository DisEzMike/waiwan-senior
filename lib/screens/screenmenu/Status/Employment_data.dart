import 'JobStatus.dart';
import 'Job_class.dart';
class EmployeeData {
  final String name;
  final EmploymentStatus status;
  // ใช้ ? เพื่อให้เป็น null ได้ถ้า status คือ notHired
  final JobDetails? currentJob; 

  EmployeeData({
    required this.name,
    required this.status,
    this.currentJob,
  }) : assert(
        // เพิ่ม Assert เพื่อให้มั่นใจว่าถ้าถูกจ้าง ต้องมีข้อมูลงาน
        status == EmploymentStatus.notHired || currentJob != null,
        'EmployeeData: ถ้าสถานะเป็น isHired ต้องมีข้อมูล currentJob ด้วย'
      );
}

// *** ข้อมูลจำลอง (Mock Data) สำหรับใช้ใน UI ***
final EmployeeData mockHiredEmployee = EmployeeData(
  name: 'บาบี้',
  status: EmploymentStatus.isHired,
  currentJob: JobDetails(
    jobTitle: 'พับกระดาษ',
    paymentAmount: 500.00,
    employerName: 'น้องกาย',
  ),
);

final EmployeeData mockNotHiredEmployee = EmployeeData(
  name: 'บาบี้',
  status: EmploymentStatus.notHired,
);