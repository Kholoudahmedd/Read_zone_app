import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/book_details.dart';

class Items extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final double rating;
  final Map<String, dynamic> bookData;

  const Items({
    super.key,
    this.imagePath = 'assets/images/image 103.png',
    this.title = 'Catcher in the Rye',
    this.author = 'J.D. Salinger',
    this.rating = 4.0,
    required this.bookData,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? const Color(0xffC86B60) : const Color(0xffFF9A8C);
    final authorColor = isDarkMode ? Colors.white54 : Colors.black54;
    final ratingBgColor =
        isDarkMode ? const Color(0xff3A6F73) : const Color(0xffAED6DC);
    final starColor =
        isDarkMode ? const Color(0xffC86B60) : const Color(0xffFF9A8C);

    return GestureDetector(
      onTap: () => _navigateToBookDetails(bookData),
      child: Container(
        height: 250,
        width: 130,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(color: cardColor),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildBookImage(),
            _buildBookTitle(),
            _buildAuthorName(authorColor),
            _buildRating(ratingBgColor, starColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage() {
    return Positioned(
      top: 8,
      child: Container(
        height: 200,
        width: 120,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBookTitle() {
    return Positioned(
      bottom: 35,
      child: SizedBox(
        width: 110,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  Widget _buildAuthorName(Color color) {
    return Positioned(
      bottom: 20,
      left: 0,
      child: SizedBox(
        width: 110,
        child: Text(
          author,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildRating(Color bgColor, Color starColor) {
    return Positioned(
      bottom: 1,
      right: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 14, color: starColor),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBookDetails(Map<String, dynamic> bookData) {
    Get.to(
      () => BookDetails(bookData: bookData),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
