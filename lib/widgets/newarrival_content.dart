import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/data/models/newarrival_model.dart';
import 'package:read_zone_app/data/repos/home_rep_impl.dart';

import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class NewarrivalContent extends StatelessWidget {
  final HomeRepoImpl homeRepo;

  const NewarrivalContent({super.key, required this.homeRepo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'New Arrival',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: getRedColor(context),
          ),
        ),
      ),
      body: FutureBuilder(
        future: homeRepo.fetchNewArrivals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: getRedColor(context),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('error ${snapshot.error}'));
          } else {
            final result = snapshot.data;
            return result!.fold(
              (failure) => Center(child: Text(failure.message)),
              (books) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return NewArrivalItem(book: book);
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class NewArrivalItem extends StatelessWidget {
  final NewArrival book;

  const NewArrivalItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GotoBookDetails(book: book);
  }
}

class GotoBookDetails extends StatelessWidget {
  const GotoBookDetails({
    super.key,
    required this.book,
  });

  final NewArrival book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(BookDetails(bookData: {
          'id': book.id,
          'title': book.title,
          'author': book.authorName,
          'description': book.description,
          'image': book.coverImageUrl,
          'rating': book.rating,
          'price': book.price,
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              book.coverImageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/book.png',
                  height: 140,
                  fit: BoxFit.fill),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            book.title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: getTextColor2(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            book.authorName,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: getGreyColor(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: getRedColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: getTextColor2(context), size: 14),
                const SizedBox(width: 4),
                Text(
                  book.rating.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: getTextColor2(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
