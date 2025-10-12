import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiwan/model/job.dart';
import 'package:waiwan/providers/font_size_provider.dart';
import 'package:waiwan/screens/job_detail_screen.dart';
import 'package:waiwan/screens/job_status_screen.dart';
import 'package:waiwan/services/job_service.dart';
import 'package:waiwan/utils/format_time.dart';
import 'package:waiwan/utils/helper.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  int _selectedIndex = 0;
  // 0 = คำขอจ้างงาน, 1 = กำลังดำเนินงาน, 2 = ประวัติการจ้าง, 3 = ยกเลิก/ปฏิเสธ

  final _jobs_completed = <MyJob>[];
  final _jobs_pending = <MyJob>[];
  final _jobs_accepted = <MyJob>[];
  final _jobs_ongoing = <MyJob>[];
  final _jobs_delined = <MyJob>[];
  final _jobs_cancelled = <MyJob>[];

  @override
  void initState() {
    super.initState();
    // _loadJobs();
  }

  @override
  void didUpdateWidget(covariant JobScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadJobs();
  }

  void _loadJobs() {
    JobService()
        .getAllJobs()
        .then((jobs) {
          final pendingJobs = <MyJob>[];
          final acceptedJobs = <MyJob>[];
          final ongoingJobs = <MyJob>[];
          final declinedJobs = <MyJob>[];
          final cancelledJobs = <MyJob>[];
          final completedJobs = <MyJob>[];
          for (var job in jobs) {
            switch (job.applicationStatus) {
              case "pending":
                if (!pendingJobs.contains(job)) {
                  pendingJobs.add(job);
                }
                break;
              case "accepted":
                if (job.status == "accepted") {
                  if (!acceptedJobs.contains(job)) {
                    acceptedJobs.add(job);
                  }
                } else if (job.status == "in_progress") {
                  if (!ongoingJobs.contains(job)) {
                    ongoingJobs.add(job);
                  } else if (job.status == "completed") {
                    if (!completedJobs.contains(job)) {
                      completedJobs.add(job);
                    }
                  }
                }
                break;
              case "declined":
                if (!declinedJobs.contains(job)) {
                  declinedJobs.add(job);
                }
                break;
              case "canceled":
                if (!cancelledJobs.contains(job)) {
                  cancelledJobs.add(job);
                }
                break;
              default:
                break;
            }

            setState(() {
              _jobs_completed.clear();
              _jobs_completed.addAll(completedJobs);
              _jobs_accepted.clear();
              _jobs_accepted.addAll(acceptedJobs);
              _jobs_pending.clear();
              _jobs_pending.addAll(pendingJobs);
              _jobs_delined.clear();
              _jobs_delined.addAll(declinedJobs);
              _jobs_cancelled.clear();
              _jobs_cancelled.addAll(cancelledJobs);
              _jobs_ongoing.clear();
              _jobs_ongoing.addAll(ongoingJobs);
            });
          }
        })
        .catchError((e) {
          debugPrint('eee : ${e.toString()}');
          showErrorSnackBar(context, e.toString());
        });
  }

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
      'รอเริ่มงาน',
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
        return _buildAcceptedJobsContent();
      case 2:
        return _buildOngoingJobsContent();
      case 3:
        return _buildJobHistoryContent();
      case 4:
        return _buildCancelledJobsContent();
      default:
        return _buildJobRequestsContent(fontProvider);
    }
  }

  Widget _buildJobRequestsContent(FontSizeProvider fontProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child:
          _jobs_pending.isNotEmpty
              ? Column(
                children: [
                  Column(
                    children:
                        _jobs_pending.map((job) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildJobCard(
                              date: start2EndDateTime(
                                job.acceptedAt ?? DateTime.now(),
                                job.startedAt,
                              ),
                              icon: Icons.mail,
                              employerName: job.userDisplayName,
                              title: job.title,
                              jobType: job.workType,
                              salary: "฿${job.price.toStringAsFixed(2)}",
                              status: job.status,
                              applicationStatus: job.applicationStatus,
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              )
              : _buildNodataContent(
                Icons.mail_outline,
                'ไม่มีคำขอจ้างงาน',
                'คุณยังไม่มีคำขอจ้างงานในขณะนี้',
              ),
    );
  }

  Widget _buildJobCard({
    required String date,
    required IconData icon,
    required String employerName,
    required String title,
    required String jobType,
    required String salary,
    required String status,
    required String applicationStatus,
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
                    (context) =>
                        (applicationStatus == "pending" || applicationStatus == "accepted" || applicationStatus == "declined") && status != "in_progress"
                            ? JobDetailScreen(
                              jobData: {
                                'date': date,
                                'icon': icon.toString(),
                                'employerName': employerName,
                                'title': title,
                                'jobType': jobType,
                                'salary': salary,
                                'status': status,
                                'applicationStatus': applicationStatus,
                              },
                            )
                            : JobStatusScreen(
                              jobData: {
                                'date': date,
                                'icon': icon.toString(),
                                'employerName': employerName,
                                'title': title,
                                'jobType': jobType,
                                'salary': salary,
                                'status': status,
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
                    child: Icon(icon, color: Colors.white, size: 32),
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
                          title,
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
                                salary,
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

  Widget _buildAcceptedJobsContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return SingleChildScrollView(
          child:
              _jobs_accepted.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children:
                          _jobs_accepted.map((job) {
                            return _buildJobCard(
                              date: start2EndDateTime(
                                job.acceptedAt ?? DateTime.now(),
                                job.startedAt,
                              ),
                              icon: Icons.access_time_filled_outlined,
                              employerName: job.userDisplayName,
                              title: job.title,
                              jobType: job.workType,
                              salary: "฿${job.price.toStringAsFixed(2)}",
                              status: job.status,
                              applicationStatus: job.applicationStatus,
                            );
                          }).toList(),
                    ),
                  )
                  : _buildNodataContent(
                    Icons.access_time,
                    'ไม่มีงานที่รอเริ่ม',
                    'คุณยังไม่มีงานที่รอเริ่มในขณะนี้',
                  ),
        );
      },
    );
  }

  Widget _buildOngoingJobsContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return SingleChildScrollView(
          child:
              _jobs_ongoing.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children:
                          _jobs_ongoing.map((job) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildJobCard(
                                date: start2EndDateTime(
                                  job.acceptedAt ?? DateTime.now(),
                                  job.startedAt,
                                ),
                                icon: Icons.work,
                                employerName: job.userDisplayName,
                                title: job.title,
                                jobType: job.workType,
                                salary: "฿${job.price.toStringAsFixed(2)}",
                                status: job.status,
                                applicationStatus: job.applicationStatus,
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : _buildNodataContent(
                    Icons.work,
                    'ไม่มีงานที่กำลังดำเนินการ',
                    'คุณยังไม่มีงานที่กำลังดำเนินการในขณะนี้',
                  ),
        );
      },
    );
  }

  Widget _buildJobHistoryContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child:
          _jobs_completed.isNotEmpty
              ? Column(
                children: [
                  Column(
                    children:
                        _jobs_completed.map((job) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildJobCard(
                              date: start2EndDateTime(
                                job.acceptedAt ?? DateTime.now(),
                                job.startedAt,
                              ),
                              icon: Icons.history,
                              employerName: job.userDisplayName,
                              title: job.title,
                              jobType: job.workType,
                              salary: "฿${job.price.toStringAsFixed(2)}",
                              status: job.status,
                              applicationStatus: job.applicationStatus,
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              )
              : _buildNodataContent(
                Icons.history,
                'ไม่มีประวัติการจ้างงาน',
                'คุณยังไม่มีประวัติการจ้างงานในขณะนี้',
              ),
    );
  }

  Widget _buildCancelledJobsContent() {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return SingleChildScrollView(
          child:
              _jobs_delined.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children:
                          _jobs_delined.map((job) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildJobCard(
                                date: start2EndDateTime(
                                  job.acceptedAt ?? DateTime.now(),
                                  job.startedAt,
                                ),
                                icon: Icons.cancel,
                                employerName: job.userDisplayName,
                                title: job.title,
                                jobType: job.workType,
                                salary: "฿${job.price.toStringAsFixed(2)}",
                                status: job.status,
                                applicationStatus: job.applicationStatus,
                              ),
                            );
                          }).toList(),
                    ),
                  )
                  : _buildNodataContent(
                    Icons.cancel_outlined,
                    'ไม่มีงานที่ถูกยกเลิก/ปฏิเสธ',
                    'คุณยังไม่มีงานที่ถูกยกเลิก/ปฏิเสธในขณะนี้',
                  ),
        );
      },
    );
  }

  Widget _buildNodataContent(IconData icon, String title, String description) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: fontProvider.getScaledFontSize(64),
                color: Colors.grey,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(16)),
              Text(
                title,
                style: TextStyle(
                  fontSize: fontProvider.getScaledFontSize(18),
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: fontProvider.getScaledFontSize(8)),
              Text(
                description,
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
