import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class BooksItems extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BooksItems({super.key, required this.bookData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BookDetails(bookData: bookData),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 300),
        );
      },
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 30),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:
                    ColorFilter.mode(getitemColor(context), BlendMode.srcIn),
                image: const AssetImage(
                  'assets/images/Rectangle.png',
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 15,
          left: 15,
          bottom: 75,
          child: Image.network(
            bookData['image'] ?? '',
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.15,
            errorBuilder: (context, error, stackTrace) =>
                Image.asset('assets/images/book.png'),
          ),
        ),
      ]),
    );
  }
}
