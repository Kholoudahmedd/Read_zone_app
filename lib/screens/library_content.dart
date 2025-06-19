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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadLibraryData();
  }

  Future<void> _loadLibraryData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final token = storage.read('token');
      final headers = {'Authorization': 'Bearer $token'};

      final responses = await Future.wait([
        dio.get('$baseUrl/audiobooks/recent',
            options: Options(headers: headers)),
        dio.get('$baseUrl/bookmarks', options: Options(headers: headers)),
        dio.get('$baseUrl/favorites', options: Options(headers: headers)),
        dio.get('$baseUrl/downloads', options: Options(headers: headers)),
      ]);

      if (!mounted) return;

      setState(() {
        recentlyPlayed = List<Map<String, dynamic>>.from(responses[0].data);
        bookmarks = List<Map<String, dynamic>>.from(responses[1].data);
        favorites = List<Map<String, dynamic>>.from(responses[2].data);
        downloads = List<Map<String, dynamic>>.from(responses[3].data);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                    fontSize: 20, fontWeight: FontWeight.bold),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: isRecentlyPlayed
                    ? RecentlyPlayedItems(bookData: item)
                    : LibraryItems(
                        id: item['id'] ?? 0,
                        title: item['title'],
                        authorName: item['authorName'],
                        coverImageUrl: item['coverImageUrl'],
                        category: item['category'] ?? 'General',
                        language: item['language'] ?? 'English',
                        rating: (item['rating'] ?? 4).toDouble(),
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
              child: CircularProgressIndicator(color: getRedColor(context)))
          : RefreshIndicator(
              color: getRedColor(context),
              onRefresh: _loadLibraryData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Library',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        color: getRedColor(context),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 100),
                              Text(
                                'Failed to load library data',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _loadLibraryData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: getRedColor(context),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                label: const Text(
                                  'Retry',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (!_hasError && _isLibraryEmpty())
                      Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/empty_library.png',
                                height: 300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Your library is empty.\nStart exploring and add your favorites!',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// عرض المكتبة إذا فيها بيانات
                    if (!_hasError && !_isLibraryEmpty()) ...[
                      _buildLibrarySection(
                        title: 'Recently Played',
                        items: recentlyPlayed,
                        destination: RecentlyPlayed(),
                        isRecentlyPlayed: true,
                      ),
                      _buildLibrarySection(
                        title: 'Bookmarks',
                        items: bookmarks,
                        destination: Bookmarks(),
                      ),
                      _buildLibrarySection(
                        title: 'Favourites',
                        items: favorites,
                        destination: FavouritesScreen(),
                      ),
                      _buildLibrarySection(
                        title: 'Downloads',
                        items: downloads,
                        destination: Downloads(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
