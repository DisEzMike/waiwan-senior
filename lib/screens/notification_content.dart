import 'package:flutter/material.dart';
import 'package:waiwan/screens/inside_notification.dart/detail_notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // ใช้ชนิดเดียวกันให้ตรงกับคลาสด้านล่าง
  List<AppNotification> _items = [
    const AppNotification(
      id: '1',
      title: 'นายกายได้ทำ',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      unread: true,
      timeText: '09:10',
    ),
    const AppNotification(
      id: '2',
      title: 'นายม่อนแจ้งสิ้น',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      unread: false,
      timeText: 'เมื่อวาน',
    ), const AppNotification(
      id: '3',
      title: 'นายกาย',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      unread: true,
      timeText: '09:10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad =
        MediaQuery.of(context).padding.bottom + kBottomNavigationBarHeight + 12;

    return Container(
      color: const Color(0xFFF3FBE9),
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPad),
        itemCount: _items.length, // ✅ ต้องระบุ
        separatorBuilder: (_, __) => const Divider(
          height: 28, thickness: 1, color: Colors.black26, indent: 72, endIndent: 16,
        ),
        itemBuilder: (context, i) {
          final it = _items[i];
          return NotificationTile(
            item: it,
            onTap: () async {
              // ทำเป็นอ่านแล้ว
              setState(() => _items[i] = it.copyWith(unread: false));
              // ไปหน้ารายละเอียด (ตัวอย่าง)
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationDetailPage(item: _items[i])),
              );
            },
          );
        },
      ),
    );
  }
}

class AppNotification {
  final String id;
  final String title;
  final String avatarUrl;
  final String? timeText;
  final bool unread;

  const AppNotification({
    required this.id,
    required this.title,
    required this.avatarUrl,
    this.timeText,
    this.unread = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? avatarUrl,
    String? timeText,
    bool? unread,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      timeText: timeText ?? this.timeText,
      unread: unread ?? this.unread,
    );
  }
}

class NotificationTile extends StatelessWidget {
  final AppNotification item;
  final VoidCallback? onTap;
  const NotificationTile({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(item.avatarUrl), // ✅ ต้องใส่ ImageProvider
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.timeText != null)
                      Text(item.timeText!, style: const TextStyle(color: Colors.black54, fontSize: 16)),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: item.unread ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.unread) ...[
                const SizedBox(width: 8),
                Container(width: 12, height: 12, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

