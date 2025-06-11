import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/rating_and_reviews_empty.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:readmore/readmore.dart';
import 'package:dio/dio.dart';

class Reviews extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const Reviews({
    super.key,
    required this.bookData,
    required this.bookId,
    required this.title,
    required this.author,
  });

  final String title;
  final int bookId;
  final String author;

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<Map<String, dynamic>> reviews = [];
  double averageRating = 0.0;
  List<double> ratingDistribution = [0, 0, 0, 0, 0];
  bool isLoading = true;
  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://myfirstapi.runasp.net/api'));

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final response = await dio.get('/reviews/${widget.bookId}');
      final List data = response.data;

      List<Map<String, dynamic>> fetchedReviews = data.map((review) {
        return {
          "userName": review['userName'] ?? "Unknown user",
          "profileImage": review['profileImage'] ?? 'assets/images/test.jpg',
          "review": review["review"] ?? "",
          "rating": (review["rating"] ?? 0.0).toDouble(),
          "time": DateTime.parse(review["time"] ?? DateTime.now().toString()),
          "userId": review["userId"] ?? "",
          "reviewId": review["id"] ?? "",
        };
      }).toList();

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
      String reviewId = reviews[index]['reviewId'];
      await dio.delete('/reviews/$reviewId');
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
                                profileImage: review['profileImage'] ??
                                    'assets/images/default.jpg',
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
                      child: reviewbutton(), // تأكد أن هذا الودجت معرف لديك
                    ),
                  ],
                ),
    );
  }
}

class ReviewContent extends StatelessWidget {
  final String userName;
  final String reviewText;
  final double rating;
  final DateTime time;
  final String profileImage;
  final VoidCallback onDelete;

  const ReviewContent({
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.time,
    required this.profileImage,
    required this.onDelete,
    super.key,
  });

  String formatTime(DateTime reviewTime) {
    try {
      Duration diff = DateTime.now().difference(reviewTime);

      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hrs ago";
      if (diff.inDays < 7) return "${diff.inDays} days ago";
      if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} weeks ago";
      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} months ago";
      return "${(diff.inDays / 365).floor()} years ago";
    } catch (e) {
      return "Unknown time";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: profileImage.startsWith('http')
                    ? NetworkImage(profileImage)
                    : AssetImage(profileImage) as ImageProvider,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (_, __) =>
                            Icon(Iconsax.star1, color: getRedColor(context)),
                        itemCount: 5,
                        rating: rating,
                        itemSize: 15,
                      ),
                      SizedBox(width: 5),
                      Text(formatTime(time),
                          style: GoogleFonts.inter(fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete',
                          style: TextStyle(color: getRedColor(context)))),
                ],
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ReadMoreText(
              reviewText,
              trimLines: 2,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          Divider(thickness: 1),
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
