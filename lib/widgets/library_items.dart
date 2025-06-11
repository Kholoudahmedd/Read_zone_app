import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/screens/book_details.dart';

class LibraryItems extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const LibraryItems({
    super.key,
    required this.bookData,
  });

  // دالة لتحديد نوع الصورة (تأكد من أنه سيتم تحميل الصورة بشكل صحيح)
  ImageProvider getImage(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/images/book.png'); // صورة افتراضية
    } else if (path.startsWith('http')) {
      return NetworkImage(path); // تحميل الصورة من الرابط
    } else {
      return AssetImage(path); // تحميل صورة من الأصول
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () =>
              BookDetails(bookData: bookData), // تمرير البيانات مع ID و Rating
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
            image: getImage(bookData['image']), // استخدام صورة الكتاب
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
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
                    bookData['title'] ?? 'No Title', // عرض عنوان الكتاب
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bookData['author'] ?? 'Unknown Author', // عرض اسم المؤلف
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
