import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart'; // مهم لرفع الصور

class AuthService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://myfirstapi.runasp.net/api/",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  final box = GetStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        "Auth/login",
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        box.write('token', response.data['token']);
        return true;
      } else {
        print("Login failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        "Auth/register",
        data: jsonEncode({
          "username": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Registration failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = box.read('token');
    if (token == null) return false;

    try {
      final response = await dio.put(
        "Auth/change-password",
        data: jsonEncode({
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Change password failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Change password error: $e");
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    final token = box.read('token');
    if (token == null) return false;

    try {
      final response = await dio.delete(
        "Auth/delete-account",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        logout(); 
        return true;
      } else {
        print("Delete account failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Delete account error: $e");
      return false;
    }
  }

  void logout() {
    box.remove('token');
  }

  bool isLoggedIn() {
    return box.read('token') != null;
  }

  String? getToken() {
    return box.read('token');
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final token = box.read('token');
    if (token == null) return null;

    try {
      final response = await dio.get(
        "Auth/profile",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Get profile failed: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Get profile error: $e");
      return null;
    }
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    String? phoneNumber,
  }) async {
    final token = box.read('token');
    if (token == null) return false;

    try {
      final response = await dio.put(
        "Auth/update-profile",
        data: jsonEncode({
          "username": username,
          "email": email,
          if (phoneNumber != null) "phoneNumber": phoneNumber,
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Update profile failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Update profile error: $e");
      return false;
    }
  }

  /// ✅ رفع صورة البروفايل
  Future<bool> uploadProfileImage(File imageFile) async {
    final token = box.read('token');
    if (token == null) return false;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'), // أو image/png حسب النوع
        ),
      });

      final response = await dio.post(
        "Auth/upload-profile-image",
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Upload image failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("Upload image error: $e");
      return false;
    }
  }
}
