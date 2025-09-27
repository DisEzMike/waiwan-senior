import 'package:flutter/material.dart';
import 'data/chatlist_data.dart'; // สำหรับ ChatItem model
import 'data/message_data.dart'; // สำหรับ ChatMessage model

class ChatScreen extends StatefulWidget {
  // รับข้อมูล chat item จากหน้า chat list
  final ChatItem chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // สร้าง List ของข้อความและ Controller สำหรับ TextField
  late List<ChatMessage> _messages;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // เลือกชุดข้อความที่จะแสดงตามชื่อของคนที่คุยด้วย
    if (widget.chat.name == 'นายกาย') {
      _messages = List.from(guyMessages);
    } else if (widget.chat.name == 'นายม่อน') {
      _messages = List.from(simonMessages);
    } else {
      _messages = []; // ถ้าไม่มีข้อมูล ให้เป็นลิสต์ว่าง
    }
  }
  
  // ฟังก์ชันสำหรับสร้าง Widget ของข้อความแต่ละอัน
  Widget _buildMessage(ChatMessage message, BuildContext context) {
    // จัดตำแหน่งข้อความ ชิดขวาถ้าเราส่ง, ชิดซ้ายถ้าเรารับ
    final alignment = message.isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = message.isSentByMe ? Colors.blue[100] : Colors.grey[200];
    final textColor = Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message.text,
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            message.time,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสำหรับส่งข้อความ
  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      // เพิ่มข้อความใหม่ลงใน List
      final newMessage = ChatMessage(
        text: _textController.text.trim(),
        time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        isSentByMe: true, // ข้อความที่ส่งจากเราเสมอ
      );
      
      // อัปเดต UI
      setState(() {
        _messages.add(newMessage);
      });

      // ล้างช่องพิมพ์
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ทำให้ปุ่ม back สวยขึ้น
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.white,
        elevation: 1,
        // ส่วนหัวของหน้าแชท
        title: Row(
          children: [
            // ปุ่ม Back
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(widget.chat.ImageUrl),
            ),
            const SizedBox(width: 12.0),
            Text(
              widget.chat.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.black,
                fontSize: 20
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ส่วนแสดงข้อความ
          Expanded(
            child: ListView.builder(
              reverse: false, // สามารถเปลี่ยนเป็น true เพื่อให้เริ่มจากด้านล่าง
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index], context);
              },
            ),
          ),

          // ส่วนพิมพ์ข้อความ
          _buildMessageComposer(),
        ],
      ),
    );
  }
  
  // Widget สำหรับช่องพิมพ์และปุ่มส่ง
  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                hintText: 'พิมพ์ข้อความ...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // อย่าลืม dispose controller เพื่อคืน memory
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}