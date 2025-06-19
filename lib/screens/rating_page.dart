import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/Reviews.dart';
import 'package:read_zone_app/screens/description_page.dart';
import 'package:read_zone_app/screens/rating_and_reviews_empty.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
  });

  final int bookId;
  final String title;
  final String author;

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  bool isDarkMode = false;
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;

  final Dio dio =
      Dio(BaseOptions(baseUrl: 'https://myfirstapi.runasp.net/api'));
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _fetchReviews();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleRefreshAfterReview();
    });
  }

  void _handleRefreshAfterReview() {
    final shouldRefresh = Get.arguments?['refresh'] ?? false;
    if (shouldRefresh) {
      _fetchReviews();
    }
  }

  void _loadTheme() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isDarkMode = prefs.getBool('isDarkMode') ?? false;
      });
    });
  }

  Future<void> _fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = storage.read('token');
      final response = await dio.get(
        '/reviews/book/${widget.bookId}',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List data = response.data;
      setState(() {
        reviews = data.map<Map<String, dynamic>>((review) {
          return {
            "userName": review['user']?['username'] ?? "Unknown user",
            "profileImage": review['user']?['profileImageUrl'] ?? "",
            "review": review["feedback"] ?? "",
            "rating": (review["rating"] ?? 0.0).toDouble(),
            "time": DateTime.parse(
                review["createdAt"] ?? DateTime.now().toString()),
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Container(
              color: getitemColor(context),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: getRedColor(context),
                labelStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.6),
                ),
                tabs: [
                  Tab(
                    icon: Image.asset(
                      isDarkMode
                          ? 'assets/Dark/rating.png'
                          : 'assets/icon/rating.png',
                      height: 30,
                      width: 30,
                    ),
                    text: 'Rating & Reviews',
                  ),
                  Tab(
                    icon: Image.asset(
                      isDarkMode
                          ? 'assets/Dark/description.png'
                          : "assets/icon/description.png",
                      height: 30,
                      width: 30,
                    ),
                    text: 'Description',
                  ),
                ],
              ),
            ),
          ),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(color: getRedColor(context)))
              : RefreshIndicator(
                  color: getRedColor(context),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  onRefresh: _fetchReviews,
                  child: TabBarView(
                    children: [
                      reviews.isEmpty
                          ? RatingAndReviewsEmpty(
                              bookId: widget.bookId,
                              title: widget.title,
                              author: widget.author,
                            )
                          : Reviews(
                              bookData: {},
                              bookId: widget.bookId,
                              title: widget.title,
                              author: widget.author,
                            ),
                      DescriptionPage(
                        bookId: widget.bookId,
                        title: widget.title,
                        author: widget.author,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
