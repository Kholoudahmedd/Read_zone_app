import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/Reviews.dart';
import 'package:read_zone_app/screens/description_page.dart';
import 'package:read_zone_app/screens/rating_and_reviews_empty.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool isDarkMode = false; // الوضع الافتراضي
  List<String> reviews = []; // قائمة التقييمات (كمثال)

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadReviews(); // تحميل التقييمات عند فتح الصفحة
  }

  void _loadTheme() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isDarkMode = prefs.getBool('isDarkMode') ?? false;
      });
    });
  }

  void _loadReviews() {
    // هنا يمكنك استبدال الكود بتحميل التقييمات من API أو قاعدة بيانات
    setState(() {
      reviews = []; // مثال على بيانات موجودة
    });
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
          body: TabBarView(
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
                    ), // ✅ التحقق من وجود التقييمات
              DescriptionPage(
                bookId: widget.bookId,
                title: widget.title,
                author: widget.author,
                bookData: {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
