import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:waiwan/screens/startapp/cash_income.dart';
import 'package:waiwan/services/auth_service.dart';

enum ExperienceLevel { certified, experienced, noExperience }

class AbilityInfoScreen extends StatefulWidget {
  final dynamic payload;

  const AbilityInfoScreen({super.key, required this.payload});

  @override
  State<AbilityInfoScreen> createState() => _AbilityInfoScreenState();
}

class _AbilityInfoScreenState extends State<AbilityInfoScreen> {
  ExperienceLevel? _selectedOption;

  File? _imageFile;
  bool? _hasVehicle;
  bool? _canWorkOffsite;

  final _jobNameController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void dispose() {
    _jobNameController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // ⭐️ 1. สร้างฟังก์ชันสำหรับแสดง Dialog แจ้งเตือน
  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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

  // ⭐️ 2. แก้ไขฟังก์ชัน submit ให้มีการตรวจสอบข้อมูล
  void _submitForm() async {
    // ตรวจสอบว่าเลือกตัวเลือกหลักหรือยัง
    if (_selectedOption == null) {
      _showValidationDialog('กรุณาเลือกประเภทความสามารถของคุณ');
      return; // หยุดการทำงาน
    }

    bool isFormValid = false;
    // ตรวจสอบข้อมูลตามตัวเลือกที่ถูกเลือก
    switch (_selectedOption!) {
      case ExperienceLevel.certified:
      case ExperienceLevel.experienced:
        // ตรวจสอบทุกช่องของฟอร์มนี้
        if (_jobNameController.text.isNotEmpty &&
            _skillsController.text.isNotEmpty &&
            _imageFile != null &&
            _hasVehicle != null &&
            _canWorkOffsite != null) {
          isFormValid = true;
        }
        break;
      case ExperienceLevel.noExperience:
        // ตรวจสอบเฉพาะช่องที่เกี่ยวข้อง
        if (_skillsController.text.isNotEmpty &&
            _hasVehicle != null &&
            _canWorkOffsite != null) {
          isFormValid = true;
        }
        break;
    }

    // ถ้าข้อมูลครบถ้วน ให้ไปหน้าต่อไป
    if (isFormValid) {
      try {
        // send to backend
        final work_experience = _jobNameController.text.isNotEmpty
            ? _jobNameController.text
            : "-";
        final payload = {
          'profile': widget.payload,
          'ability': {
            'type': _selectedOption.toString().split('.').last,
            'work_experience': work_experience,
            'other_ability': _skillsController.text,
            'vehicle': _hasVehicle,
            'offsite_work': _canWorkOffsite,
          }
        };
        final auth_code = localStorage.getItem("auth_code");
        final resp = await AuthService.authentication(auth_code!, payload);
        localStorage.setItem('userId', resp['user_id'].toString());
        localStorage.setItem('token', resp['access_token'].toString());

        localStorage.removeItem('auth_code');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CashIncomeScreen()),
        );
      } catch (e) {
        // handle error
        print('Error submitting personal info: $e');
      }
      // Navigator.pushNamed(context, '/cash_income');
    } else {
      // ถ้าข้อมูลไม่ครบ ให้แสดง Dialog แจ้งเตือน
      _showValidationDialog('กรุณากรอกข้อมูลทั้งหมดให้ครบถ้วน');
    }
  }

  Widget _buildRadioOption({
    required String title,
    required ExperienceLevel value,
  }) {
    return RadioListTile<ExperienceLevel>(
      title: Text(title, style: const TextStyle(fontSize: 24)),
      value: value,
      groupValue: _selectedOption,
      onChanged: (ExperienceLevel? newValue) {
        if (newValue == _selectedOption) return;

        setState(() {
          if (newValue == ExperienceLevel.noExperience) {
            _jobNameController.clear();
            _imageFile = null;
          }
          _selectedOption = newValue;
        });
      },
    );
  }

  Widget _buildTitledTextField({
    required String title,
    required TextEditingController controller,
    String hintText = '',
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              style: const TextStyle(fontSize: 20),
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection({required String title}) {
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
            child:
                _imageFile != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                    : const Center(
                      child: Text(
                        "ยังไม่มีรูปภาพ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.grey,
                        ),
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
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "เลือกรูปภาพจากคลัง",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ยานพาหนะ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text(
                    'มี',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  value: true,
                  groupValue: _hasVehicle,
                  onChanged: (bool? value) {
                    setState(() {
                      _hasVehicle = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text(
                    'ไม่มี',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  value: false,
                  groupValue: _hasVehicle,
                  onChanged: (bool? value) {
                    setState(() {
                      _hasVehicle = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOffsiteWorkSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ทำงานนอกสถานที่ได้",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text(
                    'ได้',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  value: true,
                  groupValue: _canWorkOffsite,
                  onChanged: (bool? value) {
                    setState(() {
                      _canWorkOffsite = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text(
                    'ไม่ได้',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  value: false,
                  groupValue: _canWorkOffsite,
                  onChanged: (bool? value) {
                    setState(() {
                      _canWorkOffsite = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicFieldSection() {
    Widget fieldSection;
    switch (_selectedOption) {
      case ExperienceLevel.certified:
        fieldSection = Column(
          children: [
            _buildTitledTextField(
              title: 'อาชีพที่เคยทำ',
              controller: _jobNameController,
              hintText: 'กรอกอาชีพที่เคยทำ',
            ),
            _buildImagePickerSection(title: "อัพโหลดรูปภาพใบรับรอง"),
            _buildTitledTextField(
              title: 'ความสามารถ',
              controller: _skillsController,
              hintText: 'ความสามารถอื่นๆ',
            ),
            _buildVehicleSelection(),
            _buildOffsiteWorkSelection(),
          ],
        );
        break;
      case ExperienceLevel.experienced:
        fieldSection = Column(
          children: [
            _buildTitledTextField(
              title: 'อาชีพที่เคยทำ',
              controller: _jobNameController,
              hintText: 'กรอกอาชีพที่เคยทำ',
            ),
            _buildImagePickerSection(title: "อัพโหลดรูปภาพการทำงาน"),
            _buildTitledTextField(
              title: 'ความสามารถ',
              controller: _skillsController,
              hintText: 'ความสามารถอื่นๆ',
            ),
            _buildVehicleSelection(),
            _buildOffsiteWorkSelection(),
          ],
        );
        break;
      case ExperienceLevel.noExperience:
        fieldSection = Column(
          children: [
            _buildTitledTextField(
              title: 'ความสามารถ',
              controller: _skillsController,
              hintText: 'ความสามารถอื่นๆ ที่มี',
            ),
            _buildVehicleSelection(),
            _buildOffsiteWorkSelection(),
          ],
        );
        break;
      default:
        fieldSection = const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        key: ValueKey<ExperienceLevel?>(_selectedOption),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: fieldSection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'ความสามารถ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ทักษะการทำงานและความสามารถ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRadioOption(
                title: 'มีใบรับรองอาชีพ',
                value: ExperienceLevel.certified,
              ),
              _buildRadioOption(
                title: 'ไม่มีใบรับรอง แต่มีประสบการณ์',
                value: ExperienceLevel.experienced,
              ),
              _buildRadioOption(
                title: 'ไม่มีประสบการณ์ทำงาน',
                value: ExperienceLevel.noExperience,
              ),
              const SizedBox(height: 20),
              _buildDynamicFieldSection(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'ถัดไป',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
