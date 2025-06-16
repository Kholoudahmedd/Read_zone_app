import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:read_zone_app/themes/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _selectedImage;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? currentImageUrl;
  final Dio _dio = Dio();
  final String baseUrl = 'https://myfirstapi.runasp.net/api';
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? getToken() => box.read('token');

  Future<void> _loadUserProfile() async {
    final token = getToken();
    if (token == null) return;

    try {
      final resp = await _dio.get(
        '$baseUrl/Auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;
      final data = resp.data;
      setState(() {
        _usernameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        currentImageUrl = data['profileImageUrl'];
      });
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<String?> _uploadImage(File file) async {
    final token = getToken();
    if (token == null) return null;

    try {
      final name = file.path.split('/').last;
      final form = FormData.fromMap({
        'Image': await MultipartFile.fromFile(file.path, filename: name),
      });

      final resp = await _dio.post(
        '$baseUrl/Auth/upload-profile-image',
        data: form,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return resp.data['imageUrl'] as String?;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _updateProfile() async {
    final token = getToken();
    if (token == null) return;

    try {
      if (_selectedImage != null) {
        final newUrl = await _uploadImage(_selectedImage!);
        if (!mounted) return;
        if (newUrl != null && newUrl.isNotEmpty) {
          currentImageUrl = newUrl;
        }
      }

      final body = {'username': _usernameController.text.trim()};
      print('Updating username with: $body');

      final resp = await _dio.put(
        '$baseUrl/Auth/update-username',
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;
      if (resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Status code: ${resp.statusCode}');
      }
    } on DioError catch (e) {
      if (!mounted) return;
      print('DioError response: ${e.response?.data}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: ${e.response?.data ?? e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final waveColor =
        isDark ? const Color(0xff272D3B) : const Color(0xff4A536B);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Subtract.png',
              width: double.infinity,
              color: getitemColor(context),
            ),
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: getGreenColor(context),
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (currentImageUrl != null &&
                                currentImageUrl!.startsWith('http'))
                            ? NetworkImage(currentImageUrl!) as ImageProvider
                            : const AssetImage('assets/images/test.jpg'),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: waveColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.upload,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildField('Username', _usernameController),
                  const SizedBox(height: 15),
                  _buildField('Email', _emailController, readOnly: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getitemColor(context),
                      minimumSize: const Size(180, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      'Update',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController ctrl, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: ctrl,
      readOnly: readOnly,
      style: TextStyle(color: getTextColor2(context)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: getTextColor2(context),
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: getGreenColor(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: getGreyColor(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
