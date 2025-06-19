import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  List<Map<String, dynamic>> _favourites = [];
  bool _isLoading = true;

  final Dio _dio = Dio();
  final String _baseUrl = 'https://myfirstapi.runasp.net/api';
  final String? _token = GetStorage().read('token');

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/UserLibrary/favorites',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _favourites = List<Map<String, dynamic>>.from(response.data);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeFavourite(String bookId) async {
    try {
      final response = await _dio.delete(
        '$_baseUrl/UserLibrary/favorites/delete/$bookId',
        options: Options(headers: {'Authorization': 'Bearer $_token'}),
      );

      if (response.statusCode == 200) {
        await _loadFavourites();
        Get.snackbar(
          'Removed from Favorites',
          'Book removed from your favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      } else {
        throw Exception('Failed to remove favorite');
      }
    } catch (e) {
      print("Error removing favorite: $e");
    }
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
            ? Center(child: CircularProgressIndicator(color: getRedColor(context)))
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
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _favourites.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = _favourites[index];
                        return _buildFavoriteItem(book);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> book) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: book['coverImageUrl'] != null &&
                    book['coverImageUrl'].toString().startsWith('http')
                ? Image.network(
                    book['coverImageUrl'],
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
                        child: Center(child: CircularProgressIndicator(color: getRedColor(context))),
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => BookDetails(bookData: {
                    'id': book['id'],
                    'title': book['title'],
                    'author': book['authorName'],
                    'image': book['coverImageUrl'],
                    'category': book['category'],
                    'language': book['language'],
                    'rating': book['rating'],
                  }),
                  transition: Transition.rightToLeft,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] ?? 'Unknown Title',
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
                    book['authorName'] ?? 'Unknown Author',
                    style: GoogleFonts.inter(
                      color: getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: getRedColor(context),
              child: const Icon(Icons.star_rounded, color: Colors.white, size: 22),
            ),
            onPressed: () => _removeFavourite(book['id'].toString()),
          ),
        ],
      ),
    );
  }
}
