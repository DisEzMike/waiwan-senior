// lib/data/chat_list_data.dart

// Model สำหรับเก็บข้อมูลของแต่ละรายการแชท
class ChatItem {
  final String name;
  final String lastMessage;
  final String time;
  final String ImageUrl; // URL ของรูปโปรไฟล์

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.ImageUrl,
  });
}

// Data จำลองสำหรับแสดงผล
final List<ChatItem> chatListData = [
  ChatItem(
    name: 'นายกาย',
    lastMessage: 'โอเคครับ เดี๋ยวผมจัดการให้',
    time: '15:30',
    ImageUrl: 'assets/images/guy.png',
  ),
  ChatItem(
    name: 'นายม่อน',
    lastMessage: 'วันนี้ 2 ทุ่ม พร้อมลั่น',
    time: '1ุ1:55',
    ImageUrl: 'assets/images/simon.png',
  ),
  
];