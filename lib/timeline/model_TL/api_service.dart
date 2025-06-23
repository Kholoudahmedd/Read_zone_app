import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../model_TL/model_post.dart';

class ApiService {
  static const String baseUrl = 'https://myfirstapi.runasp.net';

  //  استرجاع التوكن من التخزين
  static Map<String, String> getAuthHeaders() {
    final token = GetStorage().read('token');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> getAuthHeadersGet() {
    final token = GetStorage().read('token');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  //  جلب كل البوستات
  static Future<List<PostModel>> fetchPosts() async {
    final url = Uri.parse('$baseUrl/api/Timeline');

    try {
      //final response = await http.get(url);
      final response = await http.get(url, headers: getAuthHeadersGet());

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts (${response.statusCode})');
      }
    } catch (e) {
      print('Error in fetchPosts: $e');
      return [];
    }
  }

  static Future<bool> createPost({
    required String content,
    File? imageFile,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/api/Timeline');
      var request = http.MultipartRequest('POST', uri);
      request.fields['Content'] = content;

      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'Image',
          stream,
          length,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      var token = GetStorage().read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      var response = await request.send();

      // ✅ اطبع كود الاستجابة
      print('📡 Status code: ${response.statusCode}');

      // ✅ اقرأ الجسم واستعرضه
      final respStr = await response.stream.bytesToString();
      print('📩 Response body: $respStr');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('❌ Error creating post: $e');
      return false;
    }
  }

  static Future<bool> deletePost(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/$postId');

    final token = GetStorage().read('token');
    final userId = GetStorage().read('userId');

    print("🔐 Token: $token");
    print("👤 userId: $userId");
    print("🗑 postId to delete: $postId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Delete status: ${response.statusCode}');
      print('Delete response: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('❌ Error deleting post: $e');
      return false;
    }
  }

  //  لايك
  static Future<bool> likePost(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/like');
    final response = await http.post(
      url,
      headers: getAuthHeaders(),
      body: jsonEncode({'postId': postId}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  //  إلغاء لايك
  static Future<bool> unlikePost(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/like');
    final response = await http.delete(
      url,
      headers: getAuthHeaders(),
      body: jsonEncode({'postId': postId}),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  //  أسماء المعجبين
  static Future<List<Liker>> getPostLikers(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/$postId/likes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((e) => Liker.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch likes');
    }
  }

  // //  عدد اللايكات
  // ✅ الصيغة الصحيحة:
  static Future<int> getPostLikeCount(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/$postId/like-count');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // حلل JSON
      return data['likeCount'] ?? 0; // رجّع عدد اللايكات
    } else {
      throw Exception('Failed to fetch like count');
    }
  }

  static Future<List<Commenter>> getComments(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/get/$postId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.map((json) => Commenter.fromJson(json)).toList();
      } else {
        print('Failed to fetch comments: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }

  //إضافة تعليق
  static Future<bool> addComment({
    required int postId,
    required String commentText,
  }) async {
    final url = Uri.parse('$baseUrl/api/Timeline/add');

    // ✅ اطبعي التوكن قبل الإرسال
    final token = GetStorage().read('token');
    print("🧪 Saved Token: $token");

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'postId': postId,
          'text': commentText,
        }),
      );

      print('📩 Status Code: ${response.statusCode}');
      print('📩 Response Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error adding comment: $e");
      return false;
    }
  }

  static Future<int> getPostCommentCount(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/$postId/comment-count');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['commentCount'] ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }

  static Future<bool> addToFavorites(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/favorites/add');
    final token = GetStorage().read('token');
    print('🔹 URL: $url');
    print('🔹 Token: $token');
    print('🔹 Body: {"postId": $postId}');

    try {
      final response = await http.post(
        url,
        headers: getAuthHeaders(),
        body: jsonEncode({'postId': postId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> removeFromFavorites(int postId) async {
    final url = Uri.parse('$baseUrl/api/Timeline/favorites/remove');

    try {
      // 👇 هنا بتحطي request
      final request = http.Request("DELETE", url)
        ..headers.addAll({
          ...getAuthHeaders(),
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode({'postId': postId});

      // 👇 هنا بننفذ الطلب ونحوّله لـ Response
      final response = await http.Response.fromStream(await request.send());

      print('🔹 Status code: ${response.statusCode}');
      print('🔹 Response body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print(' Error removing from favorites: $e');
      return false;
    }
  }

  static Future<List<PostModel>> getFavoritePosts() async {
    final url = Uri.parse('$baseUrl/api/Timeline/favorites/list');

    try {
      final response = await http.get(
        url,
        headers: getAuthHeadersGet(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<PostModel>((item) => PostModel.fromJson(item)).toList();
      } else {
        print('Failed to fetch favorite posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching favorite posts: $e');
      return [];
    }
  }

  // جلب منشورات المستخدم الحالي
  static Future<List<PostModel>> getMyPosts() async {
    final url = Uri.parse('$baseUrl/api/Timeline/my-posts');

    try {
      final response = await http.get(
        url,
        headers: getAuthHeadersGet(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        print('Failed to load user posts: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getMyPosts: $e');
      return [];
    }
  }

  // داخل ملف api_service.dart
static Future<PostModel> getPostById(int postId) async {
  final token = GetStorage().read('token');
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  final response = await dio.get(
    '/api/Timeline/post/$postId',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    ),
  );

  if (response.statusCode == 200) {
    return PostModel.fromJson(response.data);
  } else {
    throw Exception('Failed to load post by ID');
  }
}

}
