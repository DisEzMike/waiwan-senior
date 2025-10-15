// lib/data/message_data.dart

// Model สำหรับเก็บข้อมูลของแต่ละข้อความ
class ChatMessage {
  final String text;
  final String time;
  final bool isSentByMe; // true ถ้าเป็นข้อความที่เราส่ง, false ถ้าเป็นข้อความที่รับ

  ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}

// Data จำลองสำหรับแสดงผลในหน้าแชทของ "นายกาย"
// ในแอปจริง ข้อมูลนี้จะมาจาก API หรือฐานข้อมูล
final List<ChatMessage> guyMessages = [
  ChatMessage(text: 'หวัดดีครับพี่', time: '15:28', isSentByMe: true),
  ChatMessage(text: 'ครับ ว่าไง', time: '15:28', isSentByMe: false),
  ChatMessage(text: 'พอดีโปรเจกต์ที่คุยกันไว้เรียบร้อยแล้วนะครับ', time: '15:29', isSentByMe: true),
  ChatMessage(text: 'โอเคครับ เดี๋ยวผมจัดการให้', time: '15:30', isSentByMe: false),
];

// Data จำลองสำหรับแสดงผลในหน้าแชทของ "นายม่อน"
final List<ChatMessage> simonMessages = [
  ChatMessage(text: 'ม่อน วันนี้ว่าไง', time: '11:54', isSentByMe: true),
  ChatMessage(text: 'วันนี้ 2 ทุ่ม พร้อมลั่น', time: '11:55', isSentByMe: false),
];