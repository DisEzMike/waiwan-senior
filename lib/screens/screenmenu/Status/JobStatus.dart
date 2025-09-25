/// กำหนดสถานะการจ้างงาน: 1 สำหรับถูกจ้าง, 0 สำหรับไม่ได้ถูกจ้าง
enum EmploymentStatus {
  /// 1: กำลังถูกจ้าง (มีงานปัจจุบัน)
  isHired(1),

  /// 0: ไม่ได้ถูกจ้าง (ไม่มีงานปัจจุบัน)
  notHired(0);

  final int statusValue;
  const EmploymentStatus(this.statusValue);
}