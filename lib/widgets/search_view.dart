import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:read_zone_app/screens/book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http
          .get(Uri.parse('https://myfirstapi.runasp.net/api/Books/new'));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _allBooks = data.map((json) => Book.fromJson(json)).toList();
        _filteredBooks = _allBooks;
      } else {
        _hasError = true;
      }
    } catch (e) {
      if (!mounted) return;
      _hasError = true;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _filterBooks(String query) {
    setState(() {
      _filteredBooks = _allBooks.where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = book.author.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterBooks,
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintText: 'Search by title or author',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 0, 0),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey[200],
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: getRedColor(context)))
                  : _hasError
                      ? const Center(child: Text('Failed to load books.'))
                      : _searchController.text.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/search.png',
                                      width: 300),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Start searching for books!',
                                    style: GoogleFonts.inter(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: getTextColor2(context),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _filteredBooks.isEmpty
                              ? const Center(child: Text('No results found.'))
                              : ListView.builder(
                                  itemCount: _filteredBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = _filteredBooks[index];
                                    return ListTile(
                                      title: Text(book.title),
                                      subtitle: Text(book.author),
                                      leading: Image.network(
                                        book.coverImageUrl,
                                        width: 50,
                                        height: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => BookDetails(
                                              bookData: {
                                                'id': book.id,
                                                'title': book.title,
                                                'author': book.author,
                                                'image': book.coverImageUrl,
                                                'category': book.category,
                                                'rating': book.rating,
                                                'description': book.description,
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String coverImageUrl;
  final int id;
  final String? category;
  final String? rating;
  final String? description;

  Book({
    required this.title,
    required this.author,
    required this.coverImageUrl,
    required this.id,
    this.category,
    this.rating,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: json['authorName'] ?? '',
      coverImageUrl: json['coverImageUrl'],
      id: json['id'] ?? 0,
      category: json['category'] ?? 'General',
      rating: json['rating']?.toString() ?? '0',
      description: json['description'] ?? '',
    );
  }
}
