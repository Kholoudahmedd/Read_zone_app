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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _loadLibraryData();
  }

  Future<void> _loadLibraryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      recentlyPlayed = (prefs.getStringList('recentlyPlayed') ?? [])
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
      bookmarks = (prefs.getStringList('bookmarks') ?? [])
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
      favorites = (prefs.getStringList('favorites') ?? [])
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
      downloads = (prefs.getStringList('downloads') ?? [])
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
    });
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
    bool isRecentlyPlayed = false, // للتحقق إذا كان القسم هو Recently Played
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
                      // نستخدم RecentlyPlayedItems فقط في قسم Recently Played
                      isRecentlyPlayed
                          ? RecentlyPlayedItems(bookData: item)
                          : LibraryItems(bookData: item),
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
      body: RefreshIndicator(
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
                SizedBox(height: 40),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
