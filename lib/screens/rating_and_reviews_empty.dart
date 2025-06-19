import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/rating_page.dart';
import 'package:read_zone_app/screens/write_review.dart';
import 'package:read_zone_app/themes/colors.dart';

class RatingAndReviewsEmpty extends StatefulWidget {
  const RatingAndReviewsEmpty({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
  });

  final int bookId;
  final String title;
  final String author;

  @override
  State<RatingAndReviewsEmpty> createState() => _RatingAndReviewsEmptyState();
}

class _RatingAndReviewsEmptyState extends State<RatingAndReviewsEmpty> {
  Future<void> _loadReviews() async {
    // بعد التحديث انتقل لصفحة الريفيوز
    await Future.delayed(Duration(milliseconds: 500)); // تأخير بسيط
    Get.off(() => RatingPage(
          bookId: widget.bookId,
          title: widget.title,
          author: widget.author,
        ));
  } // يمكنك تعديل البيانات حسب الحاجة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          color: getRedColor(context),
          onRefresh: _loadReviews,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: getRedColor(context),
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
                Text(
                  widget.author,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getRedColor(context),
                  ),
                ),
                SizedBox(height: 50),
                Image.asset(
                  'assets/images/review.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
                SizedBox(height: 20),
                Text(
                  'No reviews yet',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: getTextColor2(context),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                ReviewButton(
                  bookExternalId: widget.bookId,
                  title: widget.title,
                  author: widget.author,
                  bookData: {}, // يمكنك إضافة بيانات إضافية إن أردت
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewButton extends StatelessWidget {
  final int bookExternalId;
  final String title;
  final String author;
  final Map<String, dynamic> bookData;

  const ReviewButton({
    super.key,
    required this.bookExternalId,
    required this.title,
    required this.author,
    required this.bookData,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        await Get.to(() => WriteReviewScreen(bookExternalId: bookExternalId));
        Get.off(() =>
            RatingPage(bookId: bookExternalId, title: title, author: author));
      },
      child: Text(
        'Write Review',
        style: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      color: getRedColor(context),
      minWidth: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    );
  }
}
