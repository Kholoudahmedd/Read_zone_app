import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/data/failure.dart';
import 'package:read_zone_app/data/models/audio_book_search.dart';
import 'package:read_zone_app/data/models/audiobook_model.dart';
import 'package:read_zone_app/data/models/newarrival_model.dart';
import 'package:read_zone_app/data/models/popularbooks_model.dart';
import 'package:read_zone_app/data/models/book_content_model.dart';
import 'package:read_zone_app/data/models/recomendation_model.dart';
import 'package:read_zone_app/data/repos/home_repo.dart';
import 'package:read_zone_app/services/Api_service.dart';

class HomeRepoImpl implements HomeRepo {
  final ApiService2 apiService;

  HomeRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<AudioBook>>> fetchAudioBooks({String? searchQuery}) async {
    try {
      final response = await apiService.getAudioBooks(searchQuery: searchQuery);
      List<dynamic> booksData;
      if (response is List) {
        booksData = response;
      } else if (response is Map && response.containsKey('data')) {
        booksData = response['data'] as List;
      } else {
        return left(DataParsingFailure('Unexpected response format'));
      }

      try {
        final books = booksData.map((bookJson) {
          try {
            return AudioBook.fromJson(bookJson);
          } catch (e) {
            throw DataParsingFailure('Failed to parse book: $e');
          }
        }).toList();

        return right(books);
      } catch (e) {
        return left(e is Failure ? e : DataParsingFailure(e.toString()));
      }
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PopularBook>>> fetchPopularBooks() async {
    try {
      final response = await apiService.getPopularBooks();
      List<dynamic> booksData;
      if (response is List) {
        booksData = response;
      } else if (response is Map && response.containsKey('data')) {
        booksData = response['data'] as List;
      } else {
        return left(DataParsingFailure('Unexpected response format'));
      }

      try {
        final books = booksData.map((bookJson) {
          try {
            return PopularBook.fromJson(bookJson);
          } catch (e) {
            throw DataParsingFailure('Failed to parse popular book: $e');
          }
        }).toList();

        return right(books);
      } catch (e) {
        return left(e is Failure ? e : DataParsingFailure(e.toString()));
      }
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookContent>> fetchBookContent({required String bookId}) async {
    try {
      final response = await apiService.getBookContent(bookId);
      if (response is Map<String, dynamic>) {
        final content = BookContent.fromJson(response);
        return right(content);
      } else {
        return left(DataParsingFailure('Invalid content format'));
      }
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NewArrival>>> fetchNewArrivals() async {
    try {
      final response = await apiService.getNewArrivals();
      List<dynamic> booksData;

      if (response is List) {
        booksData = response;
      } else if (response is Map && response.containsKey('data')) {
        booksData = response['data'] as List;
      } else {
        return left(DataParsingFailure('Unexpected response format'));
      }

      final books = booksData.map((bookJson) {
        return NewArrival.fromJson(bookJson);
      }).toList();

      return right(books);
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SearchBook>>> searchBooks(String query) async {
    try {
      final response = await apiService.searchBooks(query);
      List<dynamic> booksData;

      if (response is List) {
        booksData = response;
      } else if (response is Map && response.containsKey('data')) {
        booksData = response['data'] as List;
      } else {
        return left(DataParsingFailure('Unexpected response format'));
      }

      try {
        final books = booksData.map((bookJson) {
          try {
            return SearchBook.fromJson(bookJson);
          } catch (e) {
            throw DataParsingFailure('Failed to parse search result: $e');
          }
        }).toList();

        return right(books);
      } catch (e) {
        return left(e is Failure ? e : DataParsingFailure(e.toString()));
      }
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  // New method for recommendations
  Future<Either<Failure, List<Recommendation>>> fetchRecommendations() async {
    try {
      final response = await apiService.getRecommendations();
      List<dynamic> booksData;

      if (response is List) {
        booksData = response;
      } else if (response is Map && response.containsKey('data')) {
        booksData = response['data'] as List;
      } else {
        return left(DataParsingFailure('Unexpected response format'));
      }

      final recommendations = booksData.map((bookJson) {
        try {
          return Recommendation.fromJson(bookJson);
        } catch (e) {
          throw DataParsingFailure('Failed to parse recommendation: $e');
        }
      }).toList();

      return right(recommendations);
    } on DioException catch (e) {
      return left(NetworkFailure(e.message ?? 'Network request failed'));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
