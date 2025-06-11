import 'package:dio/dio.dart';

class ApiService3 {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://myfirstapi.runasp.net/api/",
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  Future<void> submitReview({
    required String bookId,
    required String userId,
    required String userName,
    required String review,
    required double rating,
  }) async {
    final data = {
      'userId': userId,
      'userName': userName,
      'review': review,
      'rating': rating,
    };

    try {
      await _dio.post('Books/$bookId/reviews', data: data);
    } on DioError catch (e) {
      throw Exception('Failed to submit review: ${e.message}');
    }
  }
}
