import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class Downloads extends StatefulWidget {
  final String title;
  final String authorName;
  final String coverImageUrl;
  final String category;
  final String language;
  final double rating;

  const Downloads({
    super.key,
    required this.title,
    required this.authorName,
    required this.coverImageUrl,
    required this.category,
    required this.language,
    required this.rating,
  });

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List<dynamic> _downloadedBooks = [];
  bool _isLoading = true;
  final Dio _dio = Dio();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadDownloads();
  }

  Future<void> _loadDownloads() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final token = box.read('token');
    try {
      final response = await _dio.get(
        'https://myfirstapi.runasp.net/api/UserLibrary/downloads',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          _downloadedBooks = response.data;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching downloads: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeDownload(String bookId) async {
    final token = box.read('token');
    try {
      await _dio.delete(
        'https://myfirstapi.runasp.net/api/UserLibrary/downloads/delete/$bookId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _loadDownloads();
      if (!mounted) return;
      Get.snackbar(
        'Removed from Downloads',
        'Book removed from your downloads',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      print('Error removing download: $e');
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
            "Downloads",
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: getRedColor(context),
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: getRedColor(context)))
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
                        return _buildDownloadItem(book);
                      },
                    ),
                  ),
      ),
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> book) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (book['coverImageUrl'] != null &&
                    book['coverImageUrl'].toString().startsWith('http'))
                ? Image.network(
                    book['coverImageUrl'],
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
                            color: getRedColor(context),
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
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetails(bookData: {
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
              child: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 22,
              ),
            ),
            onPressed: () => _removeDownload(book['id'].toString()),
          ),
        ],
      ),
    );
  }
}
