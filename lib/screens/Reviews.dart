import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/rating_and_reviews_empty.dart';
import 'package:read_zone_app/services/auth_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/Review_content.dart';
import 'package:readmore/readmore.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class Reviews extends StatefulWidget {
  final Map<String, dynamic> bookData;
  final String title;
  final int bookId;
  final String author;

  const Reviews({
    super.key,
    required this.bookData,
    required this.bookId,
    required this.title,
    required this.author,
  });

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0.0;
  List<double> ratingDistribution = [0, 0, 0, 0, 0];
  bool isLoading = true;
  String? username;
  String? email;
  String? userImage;

  final String baseUrl = 'https://myfirstapi.runasp.net/';

  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://myfirstapi.runasp.net/api'));
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void loadUserProfile() async {
    final authService = AuthService();
    final profile = await authService.getProfile();

    if (!mounted) return;

    if (profile != null) {
      final profileImage = profile['profileImageUrl'];
      setState(() {
        username = profile['username'];
        email = profile['email'];
        userImage = profileImage != null && profileImage != ''
            ? '$baseUrl$profileImage'
            : null;
        isLoading = false;
      });
    } else {
      print("ERROR: Failed to load user profile");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final token = storage.read('token');
      final response = await dio.get(
        '/reviews/book/${widget.bookId}',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List data = response.data;

      List<Map<String, dynamic>> fetchedReviews = data.map((review) {
        return {
          "userName": review['user']?['username'] ?? "Unknown user",
          "profileImage": review['user']?['profileImageUrl'] ??
              'https://yourdomain.com/default_profile.png',
          "review": review["feedback"] ?? "",
          "rating": (review["rating"] ?? 0.0).toDouble(),
          "time":
              DateTime.parse(review["createdAt"] ?? DateTime.now().toString()),
          "userId": review["user"]?['id'],
          "reviewId": review["id"],
        };
      }).toList();
      fetchedReviews.sort((a, b) => b['time'].compareTo(a['time']));

      if (!mounted) return;
      setState(() {
        reviews = fetchedReviews;
        _calculateAverageRating();
      });
    } catch (e) {
      print("Error loading reviews: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _calculateAverageRating() {
    if (reviews.isEmpty) {
      averageRating = 0.0;
      ratingDistribution = [0, 0, 0, 0, 0];
      return;
    }

    double total = 0.0;
    List<double> newDistribution = [0, 0, 0, 0, 0];

    for (var review in reviews) {
      double rating = review['rating'];
      total += rating;
      int index = rating.round() - 1;
      if (index >= 0 && index < 5) newDistribution[index] += 1;
    }

    averageRating = total / reviews.length;
    ratingDistribution =
        newDistribution.map((count) => count / reviews.length).toList();
  }

  void _deleteReview(int index) async {
    try {
      final token = storage.read('token');
      String reviewId = reviews[index]['reviewId'].toString();
      await dio.delete(
        '/reviews/$reviewId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      setState(() {
        reviews.removeAt(index);
        _calculateAverageRating();
      });
    } catch (e) {
      print("Error deleting review: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: getRedColor(context)))
          : reviews.isEmpty
              ? RatingAndReviewsEmpty(
                  bookId: widget.bookId,
                  title: widget.title,
                  author: widget.author,
                )
              : Stack(
                  children: [
                    RefreshIndicator(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                      color: getRedColor(context),
                      onRefresh: _loadReviews,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Text(
                              widget.title,
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: getRedColor(context),
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                            ),
                            Text(widget.author,
                                style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: getRedColor(context))),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Color(0xffC86B60)
                                      : Color(0xffFFCCC6),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 11,
                                      child: Column(
                                        children: List.generate(5, (i) {
                                          return Rating(
                                            text: '${5 - i}',
                                            rating: ratingDistribution[4 - i],
                                          );
                                        }),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                        children: [
                                          Text(
                                            averageRating.toStringAsFixed(1),
                                            style: GoogleFonts.mulish(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          RatingBarIndicator(
                                            itemBuilder: (_, __) => Icon(
                                              Iconsax.star1,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Color(0xffFF9A8D),
                                            ),
                                            itemCount: 5,
                                            rating: averageRating,
                                            itemSize: 20,
                                          ),
                                          Text(
                                            '${reviews.length} Reviews',
                                            style: GoogleFonts.mulish(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ...reviews.asMap().entries.map((entry) {
                              int index = entry.key;
                              var review = entry.value;

                              return ReviewContent(
                                userName:
                                    review['userName'] ?? 'Anonymous user',
                                reviewText: review['review'],
                                rating: review['rating'],
                                time: review['time'],
                                profileImage: review['profileImage'],
                                onDelete: () => _deleteReview(index),
                              );
                            }),
                            SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ReviewButton(bookExternalId: widget.bookId),
                    ),
                  ],
                ),
    );
  }
}

class Rating extends StatelessWidget {
  const Rating({required this.text, required this.rating});
  final String text;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15, bottom: 5),
      child: Row(
        children: [
          Text(text, style: GoogleFonts.mulish(fontSize: 18)),
          SizedBox(width: 4),
          Icon(
            Icons.star_rate_rounded,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.5)
                : Color(0xffFF9A8D),
          ),
          SizedBox(width: 4),
          Expanded(
            flex: 11,
            child: LinearProgressIndicator(
              value: rating,
              minHeight: 5,
              valueColor: AlwaysStoppedAnimation<Color>(getGreyColor(context)),
              borderRadius: BorderRadius.circular(7),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xffC86B60)
                  : Color(0xffFFCCC6),
            ),
          ),
        ],
      ),
    );
  }
}
