import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http_parser/http_parser.dart';

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

  /// تسجيل الدخول
  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        "Auth/login",
        data: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      print("📩 Login response: ${response.data}");

      if (response.statusCode == 200 && response.data['token'] != null) {
        box.write('token', response.data['token']);

        // ✅ حفظ userId من المفتاح الصحيح "id"
        if (response.data.containsKey('id')) {
          box.write('userId', response.data['id']);
          print("✅ userId saved: ${response.data['id']}");
        } else {
          print("❗ userId (id) not found in login response");
        }

        return true;
      } else {
        print("❌ Login failed: ${response.data}");
        return false;
      }
    } catch (e) {
      print("❌ Login error: $e");
      return false;
    }
  }

  /// إنشاء حساب جديد
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

      return response.statusCode == 200;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  /// تغيير كلمة المرور
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

      return response.statusCode == 200;
    } catch (e) {
      print("Change password error: $e");
      return false;
    }
  }

  /// حذف الحساب
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

  /// تسجيل الخروج
  void logout() {
    box.remove('token');
    box.remove('userId');
  }

  /// التحقق من تسجيل الدخول
  bool isLoggedIn() {
    return box.read('token') != null;
  }

  /// جلب التوكن
  String? getToken() {
    return box.read('token');
  }

  /// جلب userId
  int? getUserId() {
    return box.read('userId');
  }

  /// جلب بيانات المستخدم الحالي
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

      return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      print("Get profile error: $e");
      return null;
    }
  }

  /// تعديل بيانات البروفايل
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

      return response.statusCode == 200;
    } catch (e) {
      print("Update profile error: $e");
      return false;
    }
  }

  /// رفع صورة البروفايل
  Future<bool> uploadProfileImage(File imageFile) async {
    final token = box.read('token');
    if (token == null) return false;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
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

      return response.statusCode == 200;
    } catch (e) {
      print("Upload image error: $e");
      return false;
    }
  }
}
