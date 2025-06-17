import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserLibraryService {
  final String baseUrl = 'https://myfirstapi.runasp.net/api/UserLibrary';
  final String? authToken; // Get this from your authentication system

  UserLibraryService(this.authToken);

  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  Future<bool> toggleFavorite(int bookId, bool isFavorite) async {
    try {
      final headers = await _getHeaders();
      final endpoint = isFavorite 
          ? '$baseUrl/favorites/add' 
          : '$baseUrl/favorites/delete/$bookId';
      
      final response = isFavorite
          ? await http.post(
              Uri.parse(endpoint),
              headers: headers,
              body: json.encode({'externalBookId': bookId}),
            )
          : await http.delete(
              Uri.parse(endpoint),
              headers: headers,
            );

      return response.statusCode == 200;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite status');
      return false;
    }
  }

  Future<bool> toggleBookmark(int bookId, bool isBookmarked) async {
    try {
      final headers = await _getHeaders();
      final endpoint = isBookmarked 
          ? '$baseUrl/bookmarks/add' 
          : '$baseUrl/bookmarks/delete/$bookId';
      
      final response = isBookmarked
          ? await http.post(
              Uri.parse(endpoint),
              headers: headers,
              body: json.encode({'externalBookId': bookId}),
            )
          : await http.delete(
              Uri.parse(endpoint),
              headers: headers,
            );

      return response.statusCode == 200;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update bookmark status');
      return false;
    }
  }

  Future<bool> toggleDownload(int bookId, bool isDownloaded) async {
    try {
      final headers = await _getHeaders();
      final endpoint = isDownloaded 
          ? '$baseUrl/downloads/add' 
          : '$baseUrl/downloads/delete/$bookId';
      
      final response = isDownloaded
          ? await http.post(
              Uri.parse(endpoint),
              headers: headers,
              body: json.encode({'externalBookId': bookId}),
            )
          : await http.delete(
              Uri.parse(endpoint),
              headers: headers,
            );

      return response.statusCode == 200;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update download status');
      return false;
    }
  }

  Future<List<dynamic>> getBookStatus(int bookId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/book-status/$bookId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [false, false, false]; // [isFavorite, isBookmarked, isDownloaded]
    } catch (e) {
      return [false, false, false];
    }
  }
}