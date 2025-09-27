import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:waiwan/screens/main_screen.dart'; 

class CashIncomeScreen extends StatefulWidget {
  const CashIncomeScreen({super.key});

  @override
  State<CashIncomeScreen> createState() => _CashIncomeScreenState();
}

class _CashIncomeScreenState extends State<CashIncomeScreen> {
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bankController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _accountNumberController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ข้อมูลไม่ครบถ้วน'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  // ⭐️ 2. แก้ไขฟังก์ชัน submit ให้ไปหน้า MyMainPage
  void _submitForm() {
    if (_accountNumberController.text.isEmpty ||
        _bankController.text.isEmpty ||
        _imageFile == null) {
      _showValidationDialog('กรุณากรอกข้อมูลทั้งหมดและอัปโหลดหลักฐาน');
    } else {
      print('Account Number: ${_accountNumberController.text}');
      print('Bank: ${_bankController.text}');
      print('Image Path: ${_imageFile!.path}');

      // ✅ เมื่อสำเร็จ ไปที่หน้า Main และลบหน้าก่อนหน้าทั้งหมดทิ้ง
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MyMainPage()),
        (route) => false,
      );
    }
  }

  Widget _buildInputField(String labelText, TextEditingController controller, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 18.0),
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerSection(
      {required String title, required Color buttonColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Center(
                    child: Text(
                      "ยังไม่มีรูปภาพ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.grey),
                    ),
                  ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor, // ใช้สีจาก Theme ที่ส่งมา
                foregroundColor: Colors.white,
              ),
              child: const Text("เลือกรูปภาพจากคลัง",
              style: TextStyle(fontSize: 20),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        title: const Text(
          'ข้อมูลรายรับเงินสด',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(
              'เลขบัญชี',
              _accountNumberController,
              'กรุณากรอกเลขบัญชีธนาคาร',
            ),
            const SizedBox(height: 20.0),
            _buildInputField(
              'ธนาคาร',
              _bankController,
              'กรุณากรอกชื่อธนาคาร',
            ),
            const SizedBox(height: 20.0),
            _buildImagePickerSection(
              title: "หลักฐานบัญชี",
              buttonColor: primaryGreen,
            ),
            const Spacer(),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'เสร็จสิ้น',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}