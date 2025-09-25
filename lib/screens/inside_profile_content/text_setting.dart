import 'package:flutter/material.dart';

class TextSizeScreen extends StatelessWidget {
  const TextSizeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _BlankPage(title: 'ขนาดตัวหนังสือ');
  }
}

class _BlankPage extends StatelessWidget {
  final String title;
  const _BlankPage({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title (หน้านี้ยังว่างอยู่)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}