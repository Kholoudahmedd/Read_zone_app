import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/write_review.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingAndReviewsEmpty extends StatefulWidget {
  const RatingAndReviewsEmpty(
      {super.key,
      required this.bookId,
      required this.title,
      required this.author});
  final int bookId;
  final String title;
  final String author;

  @override
  State<RatingAndReviewsEmpty> createState() => _RatingAndReviewsEmptyState();
}

class _RatingAndReviewsEmptyState extends State<RatingAndReviewsEmpty> {
  Future<void> _loadReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedReviews = prefs.getStringList('reviews') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RefreshIndicator(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        color: getRedColor(context),
        onRefresh: _loadReviews, // Now correctly defined inside the class
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  widget.title,
                  style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: getRedColor(context)),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(widget.author,
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: getRedColor(context))),
              SizedBox(height: 50),
              Image.asset(
                'assets/images/review.png',
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              SizedBox(height: 20),
              Text('No reviews yet',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: getTextColor2(context))),
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              ReviewButton(),
            ],
          ),
        ),
      ),
    ));
  }
}

class ReviewButton extends StatelessWidget {
  const ReviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Get.to(WriteReviewScreen());
      },
      child: Text('Write Review',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
      color: getRedColor(context),
      minWidth: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    );
  }
}

class reviewbutton extends StatelessWidget {
  const reviewbutton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Get.to(WriteReviewScreen());
      },
      child: Text('Write Review',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
      color: getRedColor(context),
      minWidth: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    );
  }
}
