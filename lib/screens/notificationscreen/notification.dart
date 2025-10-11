import 'package:flutter/material.dart';
import '../../widgets/responsive_text.dart';
import '../../utils/font_size_helper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildNotificationItem(
            'นายบาบี้ที่หนึ่งเท่านั้นได้ตอบรับงานของคุณ',
            'พับกระดาษ',
            'assets/images/guy_old.png',
            DateTime.now().subtract(const Duration(minutes: 5)),
            isRead: false,
          ),
          _buildNotificationItem(
            'ให้คะแนนรีวิว',
            'นายบาบี้ที่หนึ่งเท่านั้น',
            'assets/images/guy_old.png',
            DateTime.now().subtract(const Duration(hours: 1)),
            isRead: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, String imagePath, DateTime time, {bool isRead = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: FontSizeHelper.getScaledFontSize(50),
              height: FontSizeHelper.getScaledFontSize(50),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (!isRead)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: FontSizeHelper.getScaledFontSize(12),
                  height: FontSizeHelper.getScaledFontSize(12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: ResponsiveText(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        subtitle: ResponsiveText(
          subtitle,
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
