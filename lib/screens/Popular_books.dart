import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/data/models/popularbooks_model.dart';
import 'package:read_zone_app/data/repos/home_rep_impl.dart';
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/services/Api_service.dart';

class PopularBooks extends StatefulWidget {
  const PopularBooks({super.key});

  @override
  State<PopularBooks> createState() => _PopularBooksState();
}

class _PopularBooksState extends State<PopularBooks> {
  late HomeRepoImpl homeRepo;
  late Future<List<PopularBook>> _booksFuture;
  final TextEditingController _searchController = TextEditingController();
  List<PopularBook> _filteredBooks = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    homeRepo = HomeRepoImpl(ApiService2(Dio()));
    _booksFuture = fetchBooksFromApi();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<PopularBook>> fetchBooksFromApi() async {
    final result = await homeRepo.fetchPopularBooks();
    return result.fold(
      (failure) {
        debugPrint('Error fetching books: $failure');
        return [];
      },
      (books) {
        _filteredBooks = books;
        return books;
      },
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    _booksFuture.then((books) {
      setState(() {
        _isSearching = true;
        _filteredBooks = books.where((book) {
          return book.title.toLowerCase().contains(query) ||
              book.authorName.toLowerCase().contains(query) ||
              book.subjects
                  .any((subject) => subject.toLowerCase().contains(query));
        }).toList();
      });
    });
  }

  // void _clearSearch() {
  //   _searchController.clear();
  //   setState(() {
  //     _isSearching = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // _buildSearchField(context),
          Expanded(
            child: FutureBuilder<List<PopularBook>>(
              future: _booksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child:
                        CircularProgressIndicator(color: getRedColor(context)),
                  );
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No books found',
                      style: GoogleFonts.inter(color: getGreyColor(context)),
                    ),
                  );
                }

                final booksToDisplay =
                    _isSearching ? _filteredBooks : snapshot.data!;

                if (booksToDisplay.isEmpty) {
                  return Center(
                    child: Text(
                      'No results found',
                      style: GoogleFonts.inter(color: getGreyColor(context)),
                    ),
                  );
                }

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 30,
                      childAspectRatio: 0.49,
                    ),
                    itemCount: booksToDisplay.length,
                    itemBuilder: (context, index) {
                      final book = booksToDisplay[index];
                      return PopularBookItem(
                        bookData: {
                          "id": book.id, // هنا id كـ int
                          "title": book.title,
                          "author": book.authorName,
                          "rating": book.rating.toString(),
                          "image": book.coverImageUrl,
                          "category":
                              book.subjects.isNotEmpty ? book.subjects[0] : '',
                        },
                        isDarkMode: isDarkMode,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSearchField(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: TextField(
  //       controller: _searchController,
  //       decoration: InputDecoration(
  //         hintText: 'Search',
  //         hintStyle: GoogleFonts.inter(color: getTextColor2(context)),
  //         prefixIcon: Icon(Icons.search, color: getTextColor2(context)),
  //         suffixIcon: _searchController.text.isNotEmpty
  //             ? IconButton(
  //                 icon: Icon(Icons.clear, color: getGreyColor(context)),
  //                 onPressed: _clearSearch,
  //               )
  //             : null,
  //         filled: true,
  //         fillColor: Colors.transparent,
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(30),
  //           borderSide: BorderSide(
  //             color: getGreyColor(context),
  //             width: 1,
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(30),
  //           borderSide: BorderSide(
  //             color: getGreyColor(context),
  //             width: 1,
  //           ),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(30),
  //           borderSide: BorderSide(
  //             color: getRedColor(context),
  //             width: 1,
  //           ),
  //         ),
  //         contentPadding: const EdgeInsets.symmetric(vertical: 12),
  //       ),
  //       style: GoogleFonts.inter(),
  //     ),
  //   );
  // }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: getRedColor(context)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Popular Now',
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: getRedColor(context),
        ),
      ),
    );
  }
}

class PopularBookItem extends StatelessWidget {
  final Map<String, dynamic> bookData; // هنا استبدلنا String بـ dynamic
  final bool isDarkMode;

  const PopularBookItem({
    super.key,
    required this.bookData,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToBookDetails(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBookCover(),
          const SizedBox(height: 8),
          _buildBookInfo(context),
        ],
      ),
    );
  }

  Widget _buildBookCover() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
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
          bookData["image"] ?? '',
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            height: 150,
            child: Center(
              child: Icon(Icons.book, color: Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Text(
            bookData["title"] ?? 'No title',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bookData["author"] ?? 'Unknown author',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: getGreyColor(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        _buildRating(context),
      ],
    );
  }

  Widget _buildRating(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: getRedColor(context).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: getRedColor(context),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            bookData["rating"] ?? '0.0',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: getRedColor(context),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBookDetails() {
    Get.to(
      () => BookDetails(bookData: bookData),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
