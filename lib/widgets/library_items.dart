import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/screens/book_details.dart';

class LibraryItems extends StatelessWidget {
  final int id;
  final String title;
  final String authorName;
  final String coverImageUrl;
  final String category;
  final String language;
  final double rating;

  const LibraryItems({
    super.key,
    required this.id,
    required this.title,
    required this.authorName,
    required this.coverImageUrl,
    required this.category,
    required this.language,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // إرسال جميع البيانات المطلوبة لـ BookDetails
        Get.to(
          () => BookDetails(bookData: {
            'id': id,
            'title': title,
            'author': authorName,
            'image': coverImageUrl,
            'category': category,
            'language': language,
            'rating': rating,
          }),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Container(
        height: 180,
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: coverImageUrl.startsWith('http')
                ? NetworkImage(coverImageUrl)
                : AssetImage(coverImageUrl) as ImageProvider,
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    authorName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
