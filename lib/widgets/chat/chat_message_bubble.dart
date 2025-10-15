import 'package:flutter/material.dart';
import 'package:waiwan_senior/utils/font_size_helper.dart';
import '../../model/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String elderlyPersonName;
  final String address;
  final VoidCallback? onPaymentCompleted;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.elderlyPersonName,
    required this.address,
    this.onPaymentCompleted,
  });

  String _formatTime(DateTime timestamp) {
    return "${timestamp.toLocal().hour.toString().padLeft(2, '0')}:${timestamp.toLocal().minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return _buildTextMessage(context);
  }

  Widget _buildTextMessage(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color:
              message.isMe
                  ? const Color.fromRGBO(110, 183, 21, 1)
                  : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                message.isMe
                    ? const Radius.circular(16)
                    : const Radius.circular(4),
            bottomRight:
                message.isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: FontSizeHelper.createTextStyle(
                color: message.isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.createdAt),
              style: FontSizeHelper.createTextStyle(
                color: message.isMe ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
