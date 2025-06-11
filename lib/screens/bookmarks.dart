import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];

    setState(() {
      _bookmarks = bookmarks.map((item) {
        final book = json.decode(item);
        return {
          'id': book['id'],
          'title': book['title'] ?? 'Unknown Title',
          'author': book['author'] ?? 'Unknown Author',
          'image': book['image'] ?? 'assets/images/book.png',
          'rating': book['rating'] ?? 4,
          'pages': book['pages'] ?? 0,
          'language': book['language'] ?? 'English',
          'category': book['category'] ?? 'General',
          'lastUpdated': book['lastUpdated'] ?? DateTime.now().toString(),
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _removeBookmark(int index) async {
    if (index < 0 || index >= _bookmarks.length) return;

    final prefs = await SharedPreferences.getInstance();
    final bookmarks = List<String>.from(prefs.getStringList('bookmarks') ?? []);

    bookmarks.removeAt(index);
    await prefs.setStringList('bookmarks', bookmarks);
    await _loadBookmarks();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark removed'),
        duration: Duration(seconds: 1),
      ),
    );
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
            ? const Center(child: CircularProgressIndicator())
            : _bookmarks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          'No bookmarks yet',
                          style: GoogleFonts.inter(
                              fontSize: 18, color: getTextColor2(context)),
                        ),
                        const SizedBox(height: 8),
                      ],
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
                                  child: (book['image'] != null &&
                                          book['image']
                                              .toString()
                                              .startsWith('http'))
                                      ? Image.network(
                                          book['image'],
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
                                          builder: (context) => BookDetails(
                                            bookData: book,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book['title'],
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
                                          book['author'],
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
                                  onPressed: () => _removeBookmark(index),
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
