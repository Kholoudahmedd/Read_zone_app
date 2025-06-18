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
        height: 260,
        width: 140,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book Image
            Container(
              height: 160,
              width: 120,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                image: DecorationImage(
                  image: imagePath.startsWith('http')
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Book Title
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: SizedBox(
                width: 120,
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13, // تم تقليل حجم الخط
                      fontWeight: FontWeight.bold,
                      height: 1, // تحسين تباعد الأسطر
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // زيادة إلى سطرين
                  ),
                ),
              ),
            ),

            // Author Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 120,
                child: Tooltip(
                  message: author,
                  child: Text(
                    author,
                    style: GoogleFonts.inter(
                      fontSize: 11, // تم تقليل حجم الخط
                      color: authorColor,
                      fontWeight: FontWeight.w500, // تعديل وزن الخط
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Rating
            Padding(
              padding: const EdgeInsets.only(bottom: 1, right: 8),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ratingBgColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: starColor),
                      const SizedBox(width: 2),
                      Text(
                        rating.toStringAsFixed(1),
                        style: GoogleFonts.inter(
                          fontSize: 11, // تم تقليل حجم الخط
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
