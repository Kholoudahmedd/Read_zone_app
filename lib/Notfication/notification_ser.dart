import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class NotificationModel {
  final int id;
  final String type;
  final int? postId;
  final String sourceUsername;
  final String sourceProfileImageUrl;
  final bool isRead;
  final String createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    this.postId,
    required this.sourceUsername,
    required this.sourceProfileImageUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      postId: json['postId'],
      sourceUsername: json['sourceUsername'],
      sourceProfileImageUrl: json['sourceProfileImageUrl'] ?? '',
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }
}

class NotificationService {
  final Dio dio = Dio(BaseOptions(
    baseUrl: "https://myfirstapi.runasp.net/api/",
  ));

  final box = GetStorage();

  Future<List<NotificationModel>> fetchNotifications() async {
    final token = box.read('token');
    if (token == null) throw Exception("Token not found");

    final response = await dio.get(
      "Timeline/notifications",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      }),
    );

    if (response.statusCode == 200) {
      final data = response.data as List;
      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications: ${response.statusCode}");
    }
  }

  Future<bool> markAsRead(int notificationId) async {
    final token = box.read('token');
    if (token == null) return false;

    final response = await dio.post(
      "Timeline/notifications/$notificationId/read",
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      }),
    );

    return response.statusCode == 200;
  }
  
}
