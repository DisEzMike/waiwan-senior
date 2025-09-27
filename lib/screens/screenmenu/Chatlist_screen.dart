import 'package:flutter/material.dart';
// แก้ไข Path ให้ถูกต้อง (แนะนำให้ใช้ตัวพิมพ์เล็ก)
import 'data/chatlist_data.dart';
import 'chat_screen.dart';

class ChatlistScreen extends StatefulWidget {
  const ChatlistScreen({super.key});

  @override
  State<ChatlistScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: chatListData.length,
        itemBuilder: (context, index) {
          final chat = chatListData[index];

          // --- ส่วนที่แก้ไข: เพิ่ม InkWell เข้าไป ---
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ส่งข้อมูล 'chat' ไปให้ ChatScreen
                  builder: (_) => ChatScreen(chat: chat),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 16.0),
              child: Row(
                children: [
                  // --- ส่วนรูปโปรไฟล์ ---
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 1. กำหนดรูปทรงให้เป็นวงกลม
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5), // สีเงา
                          spreadRadius: 2, // การกระจายของเงา
                          blurRadius: 5, // ความเบลอ
                          offset: Offset(0, 2), // ตำแหน่งเงา (x, y)
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      // เพิ่มเงื่อนไขเช็คว่าเป็น URL หรือ Asset
                      backgroundImage: chat.ImageUrl.startsWith('http')
                          ? NetworkImage(chat.ImageUrl) // ถ้าเป็น URL ให้ใช้ NetworkImage
                          : AssetImage(chat.ImageUrl) as ImageProvider, // ถ้าไม่ใช่ ให้ใช้ AssetImage
                    ),
                  ),

                  const SizedBox(width: 30.0), // ช่องว่าง

                  // --- ส่วนชื่อและข้อความ ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          chat.lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- ส่วนเวลา ---
                  Text(
                    chat.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        // --- ส่วนเส้นคั่น (เหมือนเดิม) ---
        separatorBuilder: (context, index) {
          return const Divider(
            height: 3,
            thickness: 3,
            indent: 16,
            endIndent: 16,
            color: Colors.black54,
          );
        },
      ),
    );
  }
}
