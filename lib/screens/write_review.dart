import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class WriteReviewScreen extends StatefulWidget {
  final int bookExternalId;

  const WriteReviewScreen({super.key, required this.bookExternalId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  double rating = 0;
  final TextEditingController reviewController = TextEditingController();
  final Dio dio = Dio();
  final box = GetStorage();

  Future<void> submitReview() async {
    final token = box.read('token'); // Assuming you store JWT token here

    if (reviewController.text.isNotEmpty && rating > 0 && token != null) {
      Map<String, dynamic> newReview = {
        'bookExternalId': widget.bookExternalId,
        'rating': rating,
        'feedback': reviewController.text,
      };

      try {
        Response response = await dio.post(
          'https://myfirstapi.runasp.net/api/Reviews',
          data: newReview,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          showSnackBar('Review Submitted Successfully!');
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context, true); // ✅ نرجع true للتحديث
        } else {
          showSnackBar('Error: ${response.statusMessage}');
        }
      } catch (e) {
        showSnackBar('Error submitting review: $e');
      }
    } else {
      showSnackBar(token == null
          ? 'Please log in first'
          : 'Please write a review and select a rating');
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.all(20),
        elevation: 20,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
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
          icon: const Icon(Icons.arrow_back_ios),
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
              const SizedBox(height: 50),
              Text(
                'Rate the book',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getTextColor2(context),
                ),
              ),
              const SizedBox(height: 8),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 50,
                itemPadding: const EdgeInsets.symmetric(horizontal: 11),
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
              const SizedBox(height: 20),
              Text(
                'Can you tell us more?',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getTextColor2(context),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reviewController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Add feedback ...',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getRedColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
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
