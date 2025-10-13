import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waiwan/screens/main_screen.dart';
import 'package:waiwan/services/user_service.dart';
import 'package:waiwan/utils/helper.dart';
import 'package:waiwan/widgets/image_size_helper.dart';

class ProfileUploadScreen extends StatefulWidget {
  const ProfileUploadScreen({Key? key}) : super(key: key);

  @override
  State<ProfileUploadScreen> createState() => _ProfileUploadScreenState();
}

class _ProfileUploadScreenState extends State<ProfileUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  File? _cropedImage;
  Uint8List? _pickedBytes;
  final bool _isUploading = false;

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      final croppedFile = await _cropImage(imageFile: File(photo!.path));
      if (croppedFile != null) {
        final bytes = await croppedFile.readAsBytes();
        setState(() {
          _pickedImage = photo;
          _pickedBytes = bytes;
          _cropedImage = croppedFile;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ไม่สามารถเลือกภาพได้: $e')));
      }
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    try {
      CroppedFile? croppedImg = await ImageCropper().cropImage(
        maxWidth: 512,
        maxHeight: 512,
        sourcePath: imageFile.path,
        compressQuality: 100,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedImg == null) {
        return null;
      } else {
        return File(croppedImg.path);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _onConfirm() async {
    if (_cropedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเลือกรูปก่อนกดยืนยัน')),
      );
      return;
    }

    final File file = File(_cropedImage!.path);
    UserService()
        .uploadProfileImage(file)
        .catchError((e) {
          if (mounted) {
            showErrorSnackBar(context, 'อัพโหลดรูปไม่สำเร็จ');
          }
          debugPrint('Context is not mounted. Cannot show error SnackBar.');
        });

    if (mounted) {
      Navigator.of(
        context,
      ).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MyMainPage()),
        (route) => false,
      );
    }
  }

  Widget _buildPreview() {
    if (_pickedImage != null && _pickedBytes != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: CircleAvatar(
          radius: ImageSizeHelper.avatarRadius(80),
          backgroundImage: MemoryImage(_pickedBytes!),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: CircleAvatar(
        radius: ImageSizeHelper.avatarRadius(80),
        backgroundColor: Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รูปโปรไฟล์'),
        backgroundColor: const Color(0xFF5FB41F),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Make the avatar tappable to pick image
            GestureDetector(onTap: _pickFromGallery, child: _buildPreview()),
            const SizedBox(height: 18),
            // Blue rounded upload button with white bold text and small gray subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 220,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _pickFromGallery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA1F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'อัพโหลดรูปโปรไฟล์',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '(จำเป็นที่ต้องอัพโหลดรูปโปรไฟล์)',
                    style: TextStyle(color: Colors.black45, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5FB41F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isUploading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'ยืนยัน',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
