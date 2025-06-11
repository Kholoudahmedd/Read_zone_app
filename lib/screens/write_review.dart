import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
  final Dio dio = Dio();

  Future<void> submitReview() async {
    if (reviewController.text.isNotEmpty && rating > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String? userName = prefs.getString('userName') ?? 'Anonymous User';

      if (userId == null) {
        showSnackBar('Please log in to submit a review');
        return;
      }

      Map<String, dynamic> newReview = {
        'userId': userId,
        'userName': userName,
        'review': reviewController.text,
        'rating': rating,
      };

      try {
        Response response = await dio.post(
          'https://yourapi.com/api/reviews',
          data: newReview,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          showSnackBar('Review Submitted Successfully!');

          setState(() {
            reviewController.clear();
            rating = 0;
          });
        } else {
          showSnackBar('Error: ${response.statusMessage}');
        }
      } catch (e) {
        showSnackBar('Error submitting review: $e');
      }
    } else {
      showSnackBar('Please write a review and select a rating');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(20),
        elevation: 20,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Review',
          style: GoogleFonts.inter(
            color: getTextColor2(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                'Rate the book',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getTextColor2(context),
                ),
              ),
              SizedBox(height: 8),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50,
                itemPadding: EdgeInsets.symmetric(horizontal: 11),
                itemBuilder: (context, _) => Icon(
                  Iconsax.star1,
                  color: getRedColor(context),
                ),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Can you tell us more?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getTextColor2(context),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: reviewController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Add feedback ...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getRedColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  ),
                  child: Text(
                    'Submit Review',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getTextColor2(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
