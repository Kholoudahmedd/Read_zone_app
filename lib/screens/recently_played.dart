import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/audio_book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class RecentlyPlayed extends StatefulWidget {
  const RecentlyPlayed({super.key});

  @override
  _RecentlyPlayedState createState() => _RecentlyPlayedState();
}

class _RecentlyPlayedState extends State<RecentlyPlayed> {
  final Dio dio = Dio();
  final storage = GetStorage();
  List<Map<String, dynamic>> recentlyPlayedBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentlyPlayedBooks();
  }

  Future<void> _loadRecentlyPlayedBooks() async {
    try {
      final token = storage.read('token');
      final response = await dio.get(
        'https://myfirstapi.runasp.net/api/userlibrary/audiobooks/recent',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List data = response.data;
        if (!mounted) return;
        setState(() {
          recentlyPlayedBooks = data.map<Map<String, dynamic>>((book) {
            return {
              'id': book['identifier'],
              'title': book['title'] ?? 'Unknown Title',
              'author': book['creator'] ?? 'Unknown Author',
              'image': book['coverUrl'] ?? 'assets/images/book.png',
              'type': 'audio',
              'lastPlayed': book['lastPlayed'] ?? '',
              'progress': book['progress'] ?? 0.0,
              'currentChapter': book['currentChapter'] ?? 0,
              'isFavorite': book['isFavorite'] ?? false,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('Failed to load: ${response.statusCode}');
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading recently played: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _navigateToBookDetails(Map<String, dynamic> book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioBookDetails(
          title: book['title'],
          identifier: book['id'],
          creator: book['author'],
          coverUrl: book['image'],
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
          icon: Icon(Iconsax.arrow_left),
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
                        style:
                            GoogleFonts.inter(fontSize: 18, color: Colors.grey),
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
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _navigateToBookDetails(book),
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
