import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/rating_page.dart';
import 'package:read_zone_app/screens/read_now.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

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
  bool _isLoadingStatus = true;
  bool _isLoadingFavorite = false;
  bool _isLoadingBookmark = false;
  bool _isLoadingDownload = false;
  bool isDarkMode = false;
  final Dio dio = Dio();
  final box = GetStorage();

  // Recommendations state
  List<dynamic> _recommendations = [];
  bool _isLoadingRecommendations = false;

  @override
  void initState() {
    super.initState();
    _loadBookStatus();
    _loadRecommendations();
  }

  Future<void> _loadBookStatus() async {
    setState(() {
      _isLoadingStatus = true;
    });

    final token = box.read('token');
    final id = widget.bookData['id'];

    Future<void> check(String type, Function(bool) setter) async {
      try {
        final response = await dio.get(
          'https://myfirstapi.runasp.net/api/UserLibrary/$type',
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );
        final List data = response.data;
        final exists = data.any((book) => book['id'] == id);
        setter(exists);
      } catch (e) {
        print('Error loading $type status: $e');
      }
    }

    await check('favorites', (v) => _isFavorite = v);
    await check('bookmarks', (v) => _isBookmarked = v);
    await check('downloads', (v) => _isDownloaded = v);

    setState(() {
      _isLoadingStatus = false;
    });
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoadingRecommendations = true;
    });

    final recommendations =
        await _fetchRecommendations(widget.bookData['title'] ?? '');

    setState(() {
      _recommendations = recommendations;
      _isLoadingRecommendations = false;
    });
  }

  Future<List<dynamic>> _fetchRecommendations(String title) async {
    final token = box.read('token');
    try {
      final response = await dio.get(
        'https://myfirstapi.runasp.net/api/Recommendations/similar',
        queryParameters: {'title': title},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return response.data;
    } catch (e) {
      print('Error fetching recommendations: $e');
      return [];
    }
  }

  Future<void> _toggleBookStatus({
    required String type,
    required bool currentStatus,
    required Function(bool) setter,
    required Function(bool) loadingSetter,
  }) async {
    final token = box.read('token');
    final id = widget.bookData['id'];

    final String url = 'https://myfirstapi.runasp.net/api/UserLibrary/$type';
    final method = currentStatus ? 'DELETE' : 'POST';
    final endpoint = currentStatus ? '$url/delete/$id' : '$url/add';

    loadingSetter(true);
    setState(() {});

    try {
      final response = await dio.request(
        endpoint,
        data: method == 'POST' ? {"externalBookId": id} : null,
        options: Options(
          method: method,
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        setter(!currentStatus);
      }
    } catch (e) {
      print('Error toggling $type: $e');
    }

    loadingSetter(false);
    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    await _toggleBookStatus(
      type: 'favorites',
      currentStatus: _isFavorite,
      setter: (v) => _isFavorite = v,
      loadingSetter: (v) => _isLoadingFavorite = v,
    );
  }

  Future<void> _toggleBookmark() async {
    await _toggleBookStatus(
      type: 'bookmarks',
      currentStatus: _isBookmarked,
      setter: (v) => _isBookmarked = v,
      loadingSetter: (v) => _isLoadingBookmark = v,
    );
  }

  Future<void> _toggleDownload() async {
    await _toggleBookStatus(
      type: 'downloads',
      currentStatus: _isDownloaded,
      setter: (v) => _isDownloaded = v,
      loadingSetter: (v) => _isLoadingDownload = v,
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
            icon: Icon(Icons.arrow_back, color: getRedColor(context)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: _isLoadingFavorite
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: getRedColor(context),
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(
                      _isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _isFavorite
                          ? getRedColor(context)
                          : getGreyColor(context),
                    ),
              onPressed: _isLoadingFavorite ? null : _toggleFavorite,
            ),
          ],
        ),
        body: _isLoadingStatus
            ? Center(
                child: CircularProgressIndicator(color: getRedColor(context)))
            : SingleChildScrollView(
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
                        _buildRecommendationsSection(),
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
          onPressed: _isLoadingBookmark ? null : _toggleBookmark,
          child: _isLoadingBookmark
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Icon(
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
          _isLoadingDownload
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: getRedColor(context)),
                )
              : IconButton(
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

  Widget _buildRecommendationsSection() {
    if (_isLoadingRecommendations) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(color: getRedColor(context)),
        ),
      );
    }

    if (_recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'You might also like',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _recommendations.length,
            itemBuilder: (context, index) {
              final book = _recommendations[index];
              return _buildRecommendationItem(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(Map<String, dynamic> book) {
    return SizedBox(
      // Use SizedBox to constrain width
      width: 140,
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
                "category": book["subjects"] ?? '',
                'language': book['language'],
                'rating': book['rating'],
              }),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image container with fixed aspect ratio
            Container(
              height: 180,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: getitemColor(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  book['coverImageUrl'] ?? 'assets/images/book.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.book,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: getRedColor(context),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Text content with constrained width
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 130), // Prevent overflow
                    child: Text(
                      book['title'] ?? 'Unknown Title',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: Text(
                      book['authorName'] ?? 'Unknown Author',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: getTextColor(context),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
