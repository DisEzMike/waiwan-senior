class ChatMessage {
  final String senderName;
  final bool isMe;
  final String message;
  final DateTime timestamp;
  final int unreadCount;

  ChatMessage({
    required this.senderName,
    required this.isMe,
    required this.message,
    required this.timestamp,
    this.unreadCount = 0,
  });
}