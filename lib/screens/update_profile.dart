import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/themes/colors.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _pickedImage;
  String? currentImageUrl;
  bool isLoading = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
    _loadUserData();
  }

  Future<void> _requestStoragePermission() async {
    await Permission.photos.request();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      _usernameController.text = userData['username'] ?? '';
      _emailController.text = user!.email ?? '';
      currentImageUrl = userData.data()?['profileImage'];
    } catch (e) {
      print("Error loading user data: $e");
    }

    setState(() {});
  }

  Future<String?> _uploadImageToApi(File imageFile) async {
    try {
      final dio = Dio();
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path),
      });

      final response = await dio.post(
        "https://myfirstapi.runasp.net/api/Auth/upload-image", // endpoint رفع الصورة
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['imageUrl']; // تأكد أن الـ API يرجع imageUrl
      }
    } catch (e) {
      print("Error uploading image to API: $e");
    }

    return null;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The username can\'t be empty')));
      return;
    }

    try {
      setState(() => isLoading = true);
      String? imageUrl = currentImageUrl;

      if (_pickedImage != null) {
        final uploadedUrl = await _uploadImageToApi(_pickedImage!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      // تحديث في Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'username': _usernameController.text.trim(),
        if (imageUrl != null) 'profileImage': imageUrl,
      });

      // تحديث الإيميل
      if (_emailController.text.isNotEmpty &&
          _emailController.text != user!.email) {
        await user!.updateEmail(_emailController.text.trim());
      }

      // تحديث الباسورد
      if (_passwordController.text.isNotEmpty) {
        final cred = EmailAuthProvider.credential(
          email: user!.email!,
          password: _passwordController.text.trim(),
        );
        await user!.reauthenticateWithCredential(cred);
        await user!.updatePassword(_passwordController.text.trim());
      }

      // إرسال البيانات إلى API
      final dio = Dio();
      final response = await dio.put(
        'https://myfirstapi.runasp.net/api/Auth/update-profile',
        data: {
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "profileImageUrl": imageUrl ?? "",
          "newPassword": _passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("API update failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/Subtract.png',
                  width: double.infinity,
                  color: getitemColor(context),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: getTextColor2(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (currentImageUrl != null && currentImageUrl!.isNotEmpty
                          ? NetworkImage(currentImageUrl!)
                          : null) as ImageProvider?,
                  backgroundColor: Colors.grey.shade800,
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(Icons.update, color: Colors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField("Username", _usernameController),
                  SizedBox(height: 10),
                  _buildTextField("Email", _emailController),
                  SizedBox(height: 10),
                  _buildTextField("New Password", _passwordController,
                      isPassword: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Update", style: TextStyle(fontSize: 18)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: getGreenColor(context)),
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: getGreyColor(context)),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
