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

  String? currentImageUrl = '';
  final Dio _dio = Dio();
  final String baseUrl = 'https://myfirstapi.runasp.net/api';
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  String? getToken() {
    return box.read('token');
  }

  Future<void> _loadUserProfile() async {
    final token = getToken();
    if (token == null) return;

    try {
      final response = await _dio.get(
        '$baseUrl/Auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data;
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final token = getToken();
    if (token == null) return null;

    try {
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        "Image":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      final response = await _dio.post(
        '$baseUrl/Auth/upload-profile-image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data['imageUrl']; // ✅ القيمة الصحيحة من الباك اند
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
        final imageUrl = await _uploadImage(_selectedImage!);
        if (imageUrl != null && imageUrl.isNotEmpty) {
          setState(() {
            currentImageUrl = imageUrl;
          });
        }
      }

      final response = await _dio.put(
        '$baseUrl/Auth/update-username',
        data: {
          "username": _usernameController.text.trim(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Update failed with status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final waveColor = isDarkMode ? Color(0xff272D3B) : Color(0xff4A536B);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/Subtract.png',
              width: double.infinity,
              color: getitemColor(context),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: getGreenColor(context),
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (currentImageUrl != null &&
                                currentImageUrl!.startsWith('http'))
                            ? NetworkImage(currentImageUrl!)
                            : AssetImage('assets/images/test.jpg')
                                as ImageProvider,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: waveColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.upload, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  buildInputField("Username", _usernameController),
                  buildInputField("Email", _emailController, readOnly: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text(
                      "Update",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getitemColor(context),
                      fixedSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 350,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          readOnly: readOnly,
          style: TextStyle(color: getTextColor2(context)),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: getTextColor2(context),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: getGreenColor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: getGreyColor(context)),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
      ),
    );
  }
}
