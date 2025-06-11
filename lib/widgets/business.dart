import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/data/models/grouped_book_model.dart';
import 'package:read_zone_app/screens/book_details.dart';

class BusinessWidget extends StatelessWidget {
  final BookModel book;

  const BusinessWidget({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor =
        isDarkMode ? const Color(0xff3A6F73) : const Color(0xff4A536B);
    final ratingBgColor = isDarkMode
        ? const Color(0xffC86B60)
        : const Color.fromARGB(114, 255, 153, 140);

    return GestureDetector(
      onTap: () => _navigateToBookDetails(),
      child: Container(
        height: 230,
        width: 150,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookCover(context, cardColor),
            const SizedBox(height: 10),
            _buildBookInfo(context),
            const Spacer(),
            _buildRating(context, ratingBgColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context, Color bgColor) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        image: DecorationImage(
          image: NetworkImage(book.coverImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            book.authorName,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context, Color bgColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 90, bottom: 15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              size: 14,
              color: Color(0xffFF9A8C),
            ),
            const SizedBox(width: 4),
            Text(
              book.rating.toStringAsFixed(1),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBookDetails() {
    Get.to(
      () => BookDetails(
        bookData: {
          'id': book.id,
          'title': book.title,
          'author': book.authorName,
          'image': book.coverImageUrl,
          'category': book.subjects,
          'rating': book.rating,
          'price': book.price,
          'description': book.description,
        },
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
