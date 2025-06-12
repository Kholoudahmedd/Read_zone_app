import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class NotesService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://myfirstapi.runasp.net/api/', // تأكد من أن هذا هو المسار الصحيح
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  static final box = GetStorage();

  static Future<dynamic> get(String endpoint) async {
    try {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
      final response = await _dio.get(endpoint);
      return response.data;
    } catch (e) {
      print("GET $endpoint error: $e");
      return null;
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } catch (e) {
      print("POST $endpoint error: $e");
      return null;
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } catch (e) {
      print("PUT $endpoint error: $e");
      return null;
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      _dio.options.headers["Authorization"] = "Bearer ${box.read('token')}";
      final response = await _dio.delete(endpoint);
      return response.data;
    } catch (e) {
      print("DELETE $endpoint error: $e");
      return null;
    }
  }
}
