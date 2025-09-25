import 'package:flutter/material.dart';
import 'package:waiwan/screens/notification_content.dart';

// หน้าแสดงรายละเอียด (กดแล้วเข้า)
class NotificationDetailPage extends StatelessWidget {
  final AppNotification item;
  const NotificationDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายละเอียดแจ้งเตือน')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 32, backgroundImage: NetworkImage(item.avatarUrl)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
