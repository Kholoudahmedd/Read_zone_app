import 'package:dio/dio.dart';

class ApiService2 {
  final Dio dio;
  final String baseUrl;

  ApiService2(this.dio, {this.baseUrl = "https://myfirstapi.runasp.net/api/"}) {
    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 2000),
      receiveTimeout: const Duration(seconds: 2000),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
      requestHeader: true,
    ));
  }

  Future<dynamic> get({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        endPoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Status code: ${response.statusCode}',
        );
      }

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}\n'
          'Data: ${e.response?.data}',
        );
      }
      throw Exception('Network Error: ${e.message}');
    }
  }

  Future<dynamic> getAudioBooks({String? searchQuery}) async {
    return await get(
      endPoint: 'AudioBooks/home',
      queryParameters: searchQuery != null && searchQuery.isNotEmpty
          ? {'search': searchQuery}
          : null,
    );
  }

  Future<dynamic> getPopularBooks() async {
    return await get(endPoint: 'Books/popular');
  }

  Future<dynamic> getBookContent(String bookId) async {
    return await get(endPoint: 'Books/$bookId/content');
  }

  Future<dynamic> getNewArrivals() async {
    return await get(endPoint: 'Books/new');
  }

  Future<dynamic> getAllBooks() async {
    return await get(endPoint: 'Books/new');
  }

  Future<dynamic> searchBooks(String query) async {
    final response =
        await dio.get('Audiobooks/search', queryParameters: {'q': query});
    return response.data;
  }

  Future<dynamic> getRecommendations() async {
    return await get(endPoint: 'AudioBooks/home');
  }
}
