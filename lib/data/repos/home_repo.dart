import 'package:dartz/dartz.dart';
import 'package:read_zone_app/data/failure.dart';
import 'package:read_zone_app/data/models/audio_book_search.dart';
import 'package:read_zone_app/data/models/audiobook_model.dart';
import 'package:read_zone_app/data/models/book_content_model.dart';
// import 'package:read_zone_app/data/models/grouped_book_model.dart';
import 'package:read_zone_app/data/models/newarrival_model.dart';
import 'package:read_zone_app/data/models/popularbooks_model.dart';
import 'package:read_zone_app/data/models/recomendation_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<AudioBook>>> fetchAudioBooks(
      {String? searchQuery});

  Future<Either<Failure, List<PopularBook>>> fetchPopularBooks();

  Future<Either<Failure, List<NewArrival>>> fetchNewArrivals();
  Future<Either<Failure, List<Recommendation>>> fetchRecommendations();

  Future<Either<Failure, BookContent>> fetchBookContent(
      {required String bookId});
  Future<Either<Failure, List<SearchBook>>> searchBooks(String query);

  // Future<Either<Failure, List<BookModel>>> fetchAllBooks(); // ✅ دالة جديدة لجلب كل الكتب
}
