import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List<Map<String, dynamic>> _downloadedBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final downloads = prefs.getStringList('downloads') ?? [];

    setState(() {
      _downloadedBooks = downloads.map((item) {
        final book = json.decode(item);
        return {
          'title': book['title'] ?? 'Unknown Title',
          'author': book['author'] ?? 'Unknown Author',
          'image': book['image'] ?? 'assets/images/book.png',
          'rating': book['rating'] ?? 0.0,
          'pages': book['pages'] ?? 0,
          'language': book['language'] ?? 'Unknown',
        };
      }).toList();
      _isLoading = false;
    });
  }

  Future<void> _removeDownload(int index) async {
    if (index < 0 || index >= _downloadedBooks.length) return;

    final prefs = await SharedPreferences.getInstance();
    final downloads = List<String>.from(prefs.getStringList('downloads') ?? []);

    downloads.removeAt(index);
    await prefs.setStringList('downloads', downloads);
    await _loadDownloads();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Download removed'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
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
            " Downloads",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: getRedColor(context),
            ),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _downloadedBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'No Downloads Yet',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: getTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Download books to read them offline',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: getTextColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _downloadedBooks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final book = _downloadedBooks[index];
                        return _buildDownloadItem(book, index);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> book, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Book Cover with internet image support
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (book['image'] != null &&
                    book['image'].toString().startsWith('http'))
                ? Image.network(
                    book['image'],
                    width: 110,
                    height: 160,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 110,
                        height: 160,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/book.png',
                        width: 110,
                        height: 160,
                        fit: BoxFit.cover,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetails(bookData: book),
                  ),
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
                  const SizedBox(height: 10),
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
                Icons.delete_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
            onPressed: () => _removeDownload(index),
          ),
        ],
      ),
    );
  }
}
