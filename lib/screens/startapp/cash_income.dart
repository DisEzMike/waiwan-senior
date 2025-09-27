import 'package:flutter/material.dart';

class CashIncomeScreen extends StatefulWidget {
  // expects arguments: Map<String, String> with parsed id info
  const CashIncomeScreen({super.key});

  @override
  State<CashIncomeScreen> createState() => _CashIncomeScreenState();
}

class _CashIncomeScreenState extends State<CashIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    // ต้องคืนค่าเป็น Widget อย่างน้อยหนึ่งอย่างเสมอ
    // โดยปกติจะเริ่มด้วย Scaffold ซึ่งเป็นโครงสร้างพื้นฐานของหน้าจอ
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash Income'),
      ),
      body: const Center(
        child: Text('นี่คือหน้าจอรายรับเงินสด'),
      ),
    );
  }

}