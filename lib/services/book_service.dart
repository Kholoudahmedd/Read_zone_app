// book_service.dart

import 'package:dio/dio.dart';

class BookService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://myfirstapi.runasp.net/api/UserLibrary';

  Future<Map<String, List<int>>> getUserLibraryStatus(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/$userId/all');
      if (response.statusCode == 200) {
        return {
          'favorites': List<int>.from(response.data['favorites'] ?? []),
          'bookmarks': List<int>.from(response.data['bookmarks'] ?? []),
          'downloads': List<int>.from(response.data['downloads'] ?? []),
        };
      } else {
        return {'favorites': [], 'bookmarks': [], 'downloads': []};
      }
    } catch (e) {
      return {'favorites': [], 'bookmarks': [], 'downloads': []};
    }
  }

  Future<void> toggleFavorite(String userId, int bookId, bool isFavorite) async {
    final url = '$baseUrl/$userId/favorite/$bookId';
    try {
      if (isFavorite) {
        await _dio.delete(url);
      } else {
        await _dio.post(url);
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite');
    }
  }

  Future<void> toggleBookmark(String userId, int bookId, bool isBookmarked) async {
    final url = '$baseUrl/$userId/bookmark/$bookId';
    try {
      if (isBookmarked) {
        await _dio.delete(url);
      } else {
        await _dio.post(url);
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark');
    }
  }

  Future<void> toggleDownload(String userId, int bookId, bool isDownloaded) async {
    final url = '$baseUrl/$userId/download/$bookId';
    try {
      if (isDownloaded) {
        await _dio.delete(url);
      } else {
        await _dio.post(url);
      }
    } catch (e) {
      throw Exception('Failed to toggle download');
    }
  }
}

