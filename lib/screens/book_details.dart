import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/rating_page.dart';
import 'package:read_zone_app/screens/read_now.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookDetails({super.key, required this.bookData});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  bool _isFavorite = false;
  bool _isBookmarked = false;
  bool _isDownloaded = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadBookStatus();
    print("Book Data Received: ${widget.bookData}"); // Debug print
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _loadBookStatus() async {
    final prefs = await SharedPreferences.getInstance();

    // Load favorite status
    final favorites = prefs.getStringList('favorites') ?? [];
    _isFavorite = favorites.any((book) {
      final bookMap = json.decode(book);
      return bookMap['title'] == widget.bookData['title'] &&
          bookMap['id'] == widget.bookData['id'] &&
          bookMap['rating'] == widget.bookData['rating'] &&
          bookMap['author'] == widget.bookData['author'];
    });

    // Load bookmark status
    final bookmarks = prefs.getStringList('bookmarks') ?? [];
    _isBookmarked = bookmarks.any((book) {
      final bookMap = json.decode(book);
      return bookMap['title'] == widget.bookData['title'] &&
          bookMap['id'] == widget.bookData['id'] &&
          bookMap['rating'] == widget.bookData['rating'] &&
          bookMap['author'] == widget.bookData['author'];
    });

    // Load download status
    final downloads = prefs.getStringList('downloads') ?? [];
    _isDownloaded = downloads.any((book) {
      final bookMap = json.decode(book);
      return bookMap['title'] == widget.bookData['title'] &&
          bookMap['id'] == widget.bookData['id'] &&
          bookMap['rating'] == widget.bookData['rating'] &&
          bookMap['author'] == widget.bookData['author'];
    });

    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    final book = {
      'id': widget.bookData['id'] is int
          ? widget.bookData['id']
          : int.tryParse(widget.bookData['id'].toString()) ?? 0,
      'rating': widget.bookData['rating'] ?? 0,
      'title': widget.bookData['title'],
      'author': widget.bookData['author'],
      'image': widget.bookData['image'] ?? 'assets/images/book.png',
    };

    if (_isFavorite) {
      favorites.removeWhere((item) {
        final b = json.decode(item);
        return b['title'] == book['title'] &&
            b['author'] == book['author'] &&
            b['id'] == book['id'] &&
            b['rating'] == book['rating'];
      });
    } else {
      favorites.add(json.encode(book));
    }

    await prefs.setStringList('favorites', favorites);
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Get.snackbar(
    //   _isFavorite ? 'Added to Favorites' : 'Removed from Favorites',
    //   _isFavorite
    //       ? 'Book added to your favorites'
    //       : 'Book removed from favorites',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarks') ?? [];

    final book = {
      'id': widget.bookData['id'] is int
          ? widget.bookData['id']
          : int.tryParse(widget.bookData['id'].toString()) ?? 1,
      'title': widget.bookData['title'],
      'author': widget.bookData['author'],
      'image': widget.bookData['image'] ?? 'assets/images/book.png',
      'rating': widget.bookData['rating'] ?? 4,
      'pages': widget.bookData['pages'] ?? 0,
      'language': widget.bookData['language'] ?? 'English',
      'category': widget.bookData['category'] ?? 'General',
      'lastUpdated': DateTime.now().toIso8601String(),
    };

    if (_isBookmarked) {
      bookmarks.removeWhere((item) {
        final b = json.decode(item);
        return b['title'] == book['title'] &&
            b['author'] == book['author'] &&
            b['id'] == book['id'] &&
            b['rating'] == book['rating'];
      });
    } else {
      bookmarks.add(json.encode(book));
    }

    await prefs.setStringList('bookmarks', bookmarks);
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    // Get.snackbar(
    //   _isBookmarked ? 'Bookmarked' : 'Removed Bookmark',
    //   _isBookmarked
    //       ? 'Book added to your bookmarks'
    //       : 'Book removed from bookmarks',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 2),
    // );
  }

  Future<void> _toggleDownload() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> downloads = prefs.getStringList('downloads') ?? [];

    final book = {
      'id': widget.bookData['id'] is int
          ? widget.bookData['id']
          : int.tryParse(widget.bookData['id'].toString()) ?? 0,
      'rating': widget.bookData['rating'] ?? 0,
      'title': widget.bookData['title'],
      'author': widget.bookData['author'],
      'image': widget.bookData['image'] ?? 'assets/images/book.png',
    };

    if (_isDownloaded) {
      downloads.removeWhere((item) {
        final b = json.decode(item);
        return b['title'] == book['title'] && b['author'] == book['author'];
      });
    } else {
      downloads.add(json.encode(book));
    }

    await prefs.setStringList('downloads', downloads);
    setState(() {
      _isDownloaded = !_isDownloaded;
    });

    // Get.snackbar(
    //   _isDownloaded ? 'Downloaded' : 'Removed Download',
    //   _isDownloaded ? 'Book downloaded successfully' : 'Download removed',
    //   snackPosition: SnackPosition.BOTTOM,
    //   duration: const Duration(seconds: 0),
    // );
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
            icon: Icon(Icons.arrow_back, color: getRedColor(context)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color:
                    _isFavorite ? getRedColor(context) : getGreyColor(context),
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  Container(
                    color: getitemColor(context),
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  const SizedBox(height: 45),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      widget.bookData['title'] ?? 'No Title',
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(color: Colors.blueGrey, blurRadius: 5)
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.bookData['author'] ?? 'Unknown Author',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(color: Colors.blueGrey, blurRadius: 5)
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBookStatsRow(),
                  const SizedBox(height: 30),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildCategoryRow(),
                  const SizedBox(height: 20),
                  _buildBottomNavigation(),
                ],
              ),
              Positioned(
                right: 20,
                left: 20,
                top: 3,
                child: _buildBookCover(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          icon: Icons.star_rounded,
          value: (widget.bookData['rating'] ?? 0).toString(),
          label: 'Rating',
          iconColor: const Color(0xffFF9A8D),
        ),
        // _buildStatItem(
        //   value: (widget.bookData['pages'] ?? 0).toString(),
        //   label: 'Pages',
        // ),
        _buildStatItem(
          value: widget.bookData['language'] ?? 'English',
          label: 'Language',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    IconData? icon,
    required String value,
    required String label,
    Color? iconColor,
  }) {
    return Column(
      children: [
        if (icon != null)
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 5),
              Text(value,
                  style: GoogleFonts.inter(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )
        else
          Text(value,
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: getTextColor(context))),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(() => ReadNow(
                  bookId: widget.bookData['id'] ?? 0,
                  title: widget.bookData['title'] ?? 'Unknown Title',
                  author: widget.bookData['author'] ?? 'Unknown Author',
                ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: getRedColor(context),
            minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Text('Read Now',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: getTextColor2(context))),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _toggleBookmark,
          child: Icon(
            _isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: getRedColor(context),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Image.asset(
            'assets/icon/symbols_book.png',
            color: getGreyColor(context),
            height: 35,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 200,
            child: Text(
              '#${widget.bookData['category'] ?? 'General'} ',
              style:
                  GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              _isDownloaded ? Icons.download_done : Icons.download,
              color: getRedColor(context),
              size: 30,
            ),
            onPressed: _toggleDownload,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: getitemColor(context),
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(
            iconPath: isDarkMode
                ? 'assets/Dark/rating.png'
                : 'assets/icon/rating.png',
            label: 'Rating & Reviews',
            onTap: () => Get.to(
              () => RatingPage(
                bookId: widget.bookData['id'] ?? 0,
                title: widget.bookData['title'] ?? 'Unknown Title',
                author: widget.bookData['author'] ?? 'Unknown Author',
              ),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 300),
            ),
          ),
          _buildBottomNavItem(
            iconPath: isDarkMode
                ? 'assets/Dark/description.png'
                : 'assets/icon/description.png',
            label: 'Description',
            onTap: () => Get.to(
              () => RatingPage(
                bookId: widget.bookData['id'] ?? 0,
                title: widget.bookData['title'] ?? 'Unknown Title',
                author: widget.bookData['author'] ?? 'Unknown Author',
              ),
              transition: Transition.downToUp,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 30,
            width: 30,
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(147, 255, 255, 255))),
        ],
      ),
    );
  }

  Widget _buildBookCover() {
    final imageUrl = widget.bookData['image'] ?? 'assets/images/book.png';

    return imageUrl.startsWith('http')
        ? Image.network(
            imageUrl,
            height: MediaQuery.of(context).size.height * 0.45,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          )
        : Image.asset(
            imageUrl,
            height: MediaQuery.of(context).size.height * 0.45,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                _buildPlaceholderImage(),
          );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.book, size: 80, color: Colors.grey[400]),
      ),
    );
  }
}
