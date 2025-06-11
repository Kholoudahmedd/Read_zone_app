import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/screens/book_details.dart';

class NewarrivalItems extends StatelessWidget {
  final Map<String, dynamic> bookData;
  final double borderRadius;
  final EdgeInsets margin;
  final bool showDetails;

  const NewarrivalItems({
    super.key,
    required this.bookData,
    this.borderRadius = 12.0,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    this.showDetails = true,
  });

  ImageProvider getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/book.png');
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return AssetImage(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToBookDetails,
      child: Container(
        height: 180,
        width: 130,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: getImageProvider(bookData['image']),
            fit: BoxFit.cover,
          ),
        ),
        child: showDetails ? _buildBookOverlay() : null,
      ),
    );
  }

  Widget _buildBookOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.7],
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookData['title'] ?? 'No Title',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            bookData['author'] ?? 'Unknown Author',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToBookDetails() {
    Get.to(
      () => BookDetails(bookData: bookData),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
