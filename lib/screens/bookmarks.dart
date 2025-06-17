import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class Bookmarks extends StatefulWidget {
  final int id;
  final String title;
  final String authorName;
  final String coverImageUrl;
  final String category;
  final String language;
  final double rating;
  const Bookmarks({
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
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = true;
  final Dio dio = Dio();
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final token = storage.read('token');
      final response = await dio.get(
        'https://myfirstapi.runasp.net/api/UserLibrary/bookmarks',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        _bookmarks = List<Map<String, dynamic>>.from(response.data);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bookmarks: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeBookmark(int bookId) async {
    try {
      final token = storage.read('token');
      final response = await dio.delete(
        'https://myfirstapi.runasp.net/api/UserLibrary/bookmarks/delete/$bookId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        await _loadBookmarks();
        Get.snackbar(
          'Removed from Bookmarks',
          'Book removed from your bookmarks',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      } else {
        print('Failed to remove bookmark: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          title: Text(
            'Bookmarks',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: getRedColor(context),
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: getRedColor(context),
              ))
            : _bookmarks.isEmpty
                ? Center(
                    child: Text(
                      'No bookmarks yet',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: getTextColor2(context),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: getRedColor(context),
                    onRefresh: _loadBookmarks,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _bookmarks.length,
                      itemBuilder: (context, index) {
                        final book = _bookmarks[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: (book['coverImageUrl'] != null &&
                                          book['coverImageUrl']
                                              .toString()
                                              .startsWith('http'))
                                      ? Image.network(
                                          book['coverImageUrl'],
                                          height: 160,
                                          width: 110,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return SizedBox(
                                              height: 160,
                                              width: 110,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: getRedColor(context),
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/book.png',
                                              height: 160,
                                              width: 110,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          'assets/images/book.png',
                                          height: 160,
                                          width: 110,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetails(bookData: {
                                            'id': book['id'],
                                            'title': book['title'],
                                            'author': book['authorName'],
                                            'image': book['coverImageUrl'],
                                            'category': book['category'],
                                            'language': book['language'],
                                            'rating': book['rating'],
                                          }),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book['title'] ?? 'Unknown Title',
                                          style: GoogleFonts.inter(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: getTextColor2(context),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          book['authorName'] ??
                                              'Unknown Author',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: getGreyColor(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _removeBookmark(book['id']),
                                  icon: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: getRedColor(context),
                                    child: const Icon(
                                      Icons.bookmark,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
