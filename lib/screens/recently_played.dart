import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/audio_book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  List<Map<String, dynamic>> recentlyPlayedBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentlyPlayedBooks();
  }

  Future<void> _loadRecentlyPlayedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentlyPlayed = prefs.getStringList('recentlyPlayed') ?? [];

    if (!mounted) return;

    List<String> favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      recentlyPlayedBooks = recentlyPlayed.map((item) {
        Map<String, dynamic> book = json.decode(item);
        final bookJson = json.encode({
          'title': book['title'],
          'author': book['author'],
          'image': book['image'],
        });
        return {
          'title': book['title'] ?? 'Unknown Title',
          'author': book['author'] ?? 'Unknown Author',
          'image': book['image'] ?? 'assets/images/book.png',
          'type': book['type'] ?? 'audio',
          'lastPlayed': book['lastPlayed'],
          'progress': book['progress'] ?? 0.0,
          'currentChapter': book['currentChapter'] ?? 0,
          'isFavorite': favorites.contains(bookJson),
        };
      }).toList();
      isLoading = false;
    });
  }


  Future<void> _clearAllRecentlyPlayed() async {
    // عرض dialog للتأكيد
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All'),
        content: const Text(
            'Are you sure you want to clear all recently played books?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:
                Text('Cancel', style: TextStyle(color: getRedColor(context))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: getRedColor(context))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recentlyPlayed');
      if (mounted) {
        setState(() {
          recentlyPlayedBooks.clear();
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Recently played list cleared'),
          backgroundColor: getRedColor(context),
        ),
      );
    }
  }

  void _navigateToBookDetails(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioBookDetails(
          id: book['id'],
          title: book['title'],
          author: book['author'],
          image: book['image'],
        ),
      ),
    ).then((_) => _loadRecentlyPlayedBooks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Recently Played",
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: getRedColor(context),
          ),
        ),
        actions: [
          if (recentlyPlayedBooks.isNotEmpty && !isLoading)
            IconButton(
              icon: Icon(Iconsax.trash, color: getRedColor(context)),
              onPressed: _clearAllRecentlyPlayed,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: getRedColor(context)))
          : recentlyPlayedBooks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.music, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No recently played books',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: getRedColor(context),
                  onRefresh: _loadRecentlyPlayedBooks,
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: recentlyPlayedBooks.length,
                    itemBuilder: (context, index) {
                      final book = recentlyPlayedBooks[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _navigateToBookDetails(book),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: book['image'].startsWith('http')
                                      ? Image.network(
                                          book['image'],
                                          width: 80,
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            'assets/images/book.png',
                                            width: 80,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.asset(
                                          book['image'],
                                          width: 80,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book['title'],
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book['author'],
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: getGreyColor(context),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      LinearProgressIndicator(
                                        value:
                                            book['progress']?.toDouble() ?? 0.0,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          getRedColor(context),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${((book['progress'] ?? 0.0) * 100).toStringAsFixed(0)}% completed',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Text(
                                            'Chapter ${(book['currentChapter'] ?? 0) + 1}',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: getRedColor(context),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    // IconButton(
                                    //   onPressed: () => _toggleFavorite(index),
                                    //   icon: Icon(
                                    //     book['isFavorite'] == true
                                    //         ? Icons.favorite
                                    //         : Icons.favorite_border,
                                    //     color: book['isFavorite'] == true
                                    //         ? getRedColor(context)
                                    //         : Colors.grey,
                                    //   ),
                                    // ),
                                    IconButton(
                                      onPressed: () =>
                                          _navigateToBookDetails(book),
                                      icon: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: getRedColor(context),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
