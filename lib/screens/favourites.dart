import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Map<String, dynamic>> _favourites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favourites = prefs.getStringList('favorites') ?? [];

    setState(() {
      _favourites = favourites.map((item) {
        final book = json.decode(item);
        return {
          'id': book['id'],
          'title': book['title'] ?? 'Unknown Title',
          'author': book['author'] ?? 'Unknown Author',
          'image': book['image'] ?? 'assets/images/book.png',
          'rating': book['rating'] ?? 0.0,
          'pages': book['pages'] ?? 0,
          'language': book['language'] ?? 'Unknown',
          'category': book['category'] ?? 'General',
          'description': book['description'] ?? 'No description available',
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _removeFavourite(int index) async {
    if (index < 0 || index >= _favourites.length) return;

    final prefs = await SharedPreferences.getInstance();
    final favourites =
        List<String>.from(prefs.getStringList('favorites') ?? []);

    favourites.removeAt(index);
    await prefs.setStringList('favorites', favourites);
    await _loadFavourites();

    Get.snackbar(
      'Removed from Favorites',
      'Book removed from your favorites',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left, size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Favorites",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: getRedColor(context),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favourites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'No Favorites Yet',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            color: getTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _favourites.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = _favourites[index];
                        return _buildFavoriteItem(book, index);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> book, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Book Cover
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: book['image'] != null &&
                    book['image'].toString().startsWith('http')
                ? Image.network(
                    book['image'],
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/book.png',
                        width: 110,
                        height: 160,
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 110,
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/book.png',
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          // Book Details
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => BookDetails(bookData: book),
                  transition: Transition.rightToLeft,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: getTextColor2(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book['author'],
                    style: GoogleFonts.inter(
                      color: getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Remove Button
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: getRedColor(context),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            onPressed: () => _removeFavourite(index),
          ),
        ],
      ),
    );
  }
}
