/// ข้อมูลรายละเอียดงานปัจจุบัน สำหรับกรณีที่สถานะคือ 'isHired'
class JobDetails {
  final String jobTitle; // 'พับกระดาษ'
  final double paymentAmount; // 500.00
  final String employerName; // 'น้องกาย'

  JobDetails({
    required this.jobTitle,
    required this.paymentAmount,
    required this.employerName,
  });
}