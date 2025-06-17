import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/bookmarks.dart';
import 'package:read_zone_app/screens/downloads.dart';
import 'package:read_zone_app/screens/favourites.dart';
import 'package:read_zone_app/screens/recently_played.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/library_items.dart';
import 'package:read_zone_app/widgets/recently_played_items.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class LibraryContent extends StatefulWidget {
  const LibraryContent({super.key});

  @override
  State<LibraryContent> createState() => _LibraryContentState();
}

class _LibraryContentState extends State<LibraryContent> {
  List<Map<String, dynamic>> recentlyPlayed = [];
  List<Map<String, dynamic>> bookmarks = [];
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> downloads = [];

  final Dio dio = Dio();
  final storage = GetStorage();

  final String baseUrl = 'https://myfirstapi.runasp.net/api/UserLibrary';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLibraryData();
  }

  Future<void> _loadLibraryData() async {
    try {
      final token = storage.read('token');

      final headers = {'Authorization': 'Bearer $token'};

      final responses = await Future.wait([
        dio.get('$baseUrl/recent', options: Options(headers: headers)),
        dio.get('$baseUrl/bookmarks', options: Options(headers: headers)),
        dio.get('$baseUrl/favorites', options: Options(headers: headers)),
        dio.get('$baseUrl/downloads', options: Options(headers: headers)),
      ]);

      setState(() {
        recentlyPlayed = List<Map<String, dynamic>>.from(responses[0].data);
        bookmarks = List<Map<String, dynamic>>.from(responses[1].data);
        favorites = List<Map<String, dynamic>>.from(responses[2].data);
        downloads = List<Map<String, dynamic>>.from(responses[3].data);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading library data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLibraryEmpty() {
    return recentlyPlayed.isEmpty &&
        bookmarks.isEmpty &&
        favorites.isEmpty &&
        downloads.isEmpty;
  }

  Widget _buildLibrarySection({
    required String title,
    required List<Map<String, dynamic>> items,
    required Widget destination,
    bool showSeeAll = true,
    bool isRecentlyPlayed = false,
  }) {
    if (items.isEmpty) return SizedBox();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showSeeAll && items.length > 3)
                TextButton(
                  onPressed: () => Get.to(() => destination),
                  child: Text(
                    'See all >',
                    style: GoogleFonts.inter(
                      color: getGreyColor(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length > 3 ? 3 : items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  if (isRecentlyPlayed) {
                    Get.to(() => RecentlyPlayedItems(bookData: item));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      isRecentlyPlayed
                          ? RecentlyPlayedItems(bookData: item)
                          : LibraryItems(
                              id: item['id'],
                              title: item['title'],
                              authorName: item['authorName'],
                              coverImageUrl: item['coverImageUrl'],
                              category: item['subjects'] ?? 'General',
                              language: item['language'] ?? 'English',
                              rating: (item['rating'] ?? 4).toDouble(),
                            ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: getRedColor(context),
              ),
            )
          : RefreshIndicator(
              color: getRedColor(context),
              onRefresh: _loadLibraryData,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          Text(
                            'Library',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.black.withOpacity(0.1),
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  offset: Offset(1.0, 1.0),
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Library',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: getRedColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_isLibraryEmpty())
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 200),
                        child: Center(
                          child: Text(
                            'No items available in your library',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (!_isLibraryEmpty()) ...[
                      _buildLibrarySection(
                        title: 'Recently Played',
                        items: recentlyPlayed,
                        destination: RecentlyPlayed(),
                        isRecentlyPlayed: true,
                      ),
                      _buildLibrarySection(
                        title: 'Bookmarks',
                        items: bookmarks,
                        destination: Bookmarks(
                          id: bookmarks.isNotEmpty ? bookmarks[0]['id'] : null,
                          title:
                              bookmarks.isNotEmpty ? bookmarks[0]['title'] : '',
                          authorName: bookmarks.isNotEmpty
                              ? bookmarks[0]['authorName']
                              : '',
                          coverImageUrl: bookmarks.isNotEmpty
                              ? bookmarks[0]['coverImageUrl']
                              : '',
                          category: bookmarks.isNotEmpty
                              ? (bookmarks[0]['category'] ?? 'General')
                              : 'General',
                          language: bookmarks.isNotEmpty
                              ? (bookmarks[0]['language'] ?? 'English')
                              : 'English',
                          rating: bookmarks.isNotEmpty
                              ? (bookmarks[0]['rating'] ?? 4).toDouble()
                              : 4.0,
                        ),
                      ),
                      _buildLibrarySection(
                        title: 'Favourites',
                        items: favorites,
                        destination: FavouritesScreen(
                          id: favorites.isNotEmpty ? favorites[0]['id'] : null,
                          title:
                              favorites.isNotEmpty ? favorites[0]['title'] : '',
                          authorName: favorites.isNotEmpty
                              ? favorites[0]['authorName']
                              : '',
                          coverImageUrl: favorites.isNotEmpty
                              ? favorites[0]['coverImageUrl']
                              : '',
                          category: favorites.isNotEmpty
                              ? (favorites[0]['category'] ?? 'General')
                              : 'General',
                          language: favorites.isNotEmpty
                              ? (favorites[0]['language'] ?? 'English')
                              : 'English',
                          rating: favorites.isNotEmpty
                              ? (favorites[0]['rating'] ?? 4).toDouble()
                              : 4.0,
                        ),
                      ),
                      _buildLibrarySection(
                        title: 'Downloads',
                        items: downloads,
                        destination: Downloads(
                          title:
                              downloads.isNotEmpty ? downloads[0]['title'] : '',
                          authorName: downloads.isNotEmpty
                              ? downloads[0]['authorName']
                              : '',
                          coverImageUrl: downloads.isNotEmpty
                              ? downloads[0]['coverImageUrl']
                              : '',
                          category: downloads.isNotEmpty
                              ? (downloads[0]['category'] ?? 'General')
                              : 'General',
                          language: downloads.isNotEmpty
                              ? (downloads[0]['language'] ?? 'English')
                              : 'English',
                          rating: downloads.isNotEmpty
                              ? (downloads[0]['rating'] ?? 4).toDouble()
                              : 4.0,
                        ),
                      ),
                      SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
