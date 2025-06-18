import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class scienceContent extends StatelessWidget {
  const scienceContent({super.key});

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final response = await http.get(
        Uri.parse('https://myfirstapi.runasp.net/api/books/sections/science'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((book) => book as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

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
          'science',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: getRedColor(context),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: getRedColor(context),
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available.'));
          }

          final books = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                return BusinessItem(
                  title: book['title'],
                  authorName: book['authorName'],
                  rating: book['rating'].toString(),
                  coverImageUrl: book['coverImageUrl'],
                  bookData: book,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class BusinessItem extends StatelessWidget {
  final String title;
  final String authorName;
  final String rating;
  final String coverImageUrl;
  final Map<String, dynamic> bookData;

  const BusinessItem({
    super.key,
    required this.title,
    required this.authorName,
    required this.rating,
    required this.coverImageUrl,
    required this.bookData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(BookDetails(
          bookData: {
            'id': bookData['id'],
            'title': bookData['title'],
            'author': bookData['authorName'],
            'image': bookData['coverImageUrl'],
            'category': bookData['subjects'],
            'rating': bookData['rating'],
            'price': bookData['price'],
            'description': bookData['description'],
          },
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              coverImageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: getTextColor2(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            authorName,
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
                  rating,
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
