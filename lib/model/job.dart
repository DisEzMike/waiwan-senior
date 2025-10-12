enum JobApplicationStatus { pending, accepted, declined, canceled }

class MyJob {
  final int id;
  final String title;
  final String description;
  final double price;
  final String workType;
  final bool vehicle;
  final dynamic location;
  final String status;
  final String applicationStatus;
  final String userId;
  final String userDisplayName;
  DateTime? acceptedAt;
  DateTime? startedAt;
  DateTime? endedAt;
  double? durationHours;
  final bool isCompleted;
  final bool isActive;
  String? chatRoomId;

  MyJob({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.workType,
    required this.vehicle,
    required this.location,
    required this.status,
    required this.applicationStatus,
    required this.userId,
    required this.userDisplayName,
    this.acceptedAt,
    this.startedAt,
    this.endedAt,
    this.durationHours,
    this.isCompleted = false,
    this.isActive = false,
    this.chatRoomId,
  });

  factory MyJob.fromJson(Map<String, dynamic> json) {
    return MyJob(
      id: json['job_id'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      price: (json['price'] as num).toDouble(),
      workType: json['work_type'] ?? "",
      vehicle: json['vehicle'] ?? false,
      location: json['location'],
      status: json['status'] ?? "",
      applicationStatus: json['application_status'] ?? "",
      userId: json['user_id'] ?? "",
      userDisplayName: json['user_displayname'] ?? "",
      acceptedAt:
          json['accepted_at'] != null
              ? DateTime.parse(json['accepted_at'])
              : null,
      startedAt:
          json['started_at'] != null
              ? DateTime.parse(json['started_at'])
              : null,
      endedAt:
          json['ended_at'] != null ? DateTime.parse(json['ended_at']) : null,
      durationHours:
          json['duration_hours'] != null
              ? (json['duration_hours'] as num).toDouble()
              : null,
      isCompleted: json['is_completed'] ?? false,
      isActive: json['is_active'] ?? false,
      chatRoomId: json['chat_room_id'],
    );
  }

  toJson() {
    return {
      'job_id': id,
      'title': title,
      'description': description,
      'price': price,
      'work_type': workType,
      'vehicle': vehicle,
      'location': location,
      'status': status,
      'application_status': applicationStatus,
      'user_id': userId,
      'user_displayname': userDisplayName,
      'accepted_at': acceptedAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_hours': durationHours,
      'is_completed': isCompleted,
      'is_active': isActive,
      'chat_room_id': chatRoomId,
    };
  }
}
