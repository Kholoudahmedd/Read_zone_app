import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/Items.dart';

class HomeTabs extends StatefulWidget {
  const HomeTabs({super.key});

  @override
  State<HomeTabs> createState() => _HomeTabsState();
}

class _HomeTabsState extends State<HomeTabs> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = [
    'Adventure',
    'History',
    'Drama',
    'Mystery',
    'Fantasy'
  ];
  final Map<String, String> apiCategories = {
    'Adventure': 'adventure',
    'History': 'history',
    'Drama': 'drama',
    'Mystery': 'mystery',
    'Fantasy': 'fantasy',
  };

  final Dio _dio = Dio();
  final String baseUrl = "https://myfirstapi.runasp.net/api/books/sections";
  Map<String, List<Map<String, dynamic>>> booksData = {};
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
    _fetchAllTabsData();
  }

  Future<void> _fetchAllTabsData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      for (var tab in categories) {
        final response = await _dio.get('$baseUrl/${apiCategories[tab]}');
        final List<dynamic> data = response.data;
        booksData[tab] = data.map<Map<String, dynamic>>((book) {
          return {
            "id": book["id"],
            "title": book["title"],
            "author": book["authorName"],
            "rating": book["rating"].toString(),
            "image": book["coverImageUrl"],
            "category": book["subjects"] ?? '',
          };
        }).toList();
      }
    } catch (e) {
      print('Error loading tab data: $e');
      hasError = true;
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: categories.map((c) => Tab(text: c)).toList(),
          labelColor: isDarkMode ? Colors.white : Colors.black,
          labelStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          tabAlignment: TabAlignment.center,
          isScrollable: true,
          labelPadding: const EdgeInsets.symmetric(horizontal: 20),
          unselectedLabelColor: isDarkMode
              ? Colors.grey.shade600
              : const Color.fromARGB(145, 74, 83, 107),
          dividerColor: Colors.transparent,
          indicatorColor:
              isDarkMode ? const Color(0xffC86B60) : const Color(0xffFF9A8C),
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: getRedColor(context),
                  ),
                )
              : hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Failed to load books",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _fetchAllTabsData,
                            // icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: getRedColor(context),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: categories.map((tab) {
                        final books = booksData[tab] ?? [];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return Items(
                              imagePath: book["image"] ??
                                  'assets/images/image 103.png',
                              title: book["title"] ?? "No Title",
                              author: book["author"] ?? "Unknown",
                              rating: double.tryParse(book["rating"]) ?? 0.0,
                              bookData: book,
                            );
                          },
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }
}
