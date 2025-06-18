import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/data/models/Audiobook_model.dart';
import 'package:read_zone_app/screens/audio_book_details.dart';
import 'package:read_zone_app/themes/colors.dart';

class AudioBooksScreen extends StatefulWidget {
  const AudioBooksScreen({super.key});

  @override
  State<AudioBooksScreen> createState() => _AudioBooksScreenState();
}

class _AudioBooksScreenState extends State<AudioBooksScreen> {
  late Future<List<AudioBook>> _audioBooksFuture;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = Dio();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _initializeDio();
    _audioBooksFuture = _loadAudioBooks();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://myfirstapi.runasp.net/api/AudioBooks/',
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
    );
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<List<AudioBook>> _loadAudioBooks({String? query}) async {
    try {
      final response = await _dio.get(
        query != null && query.isNotEmpty ? 'search' : 'home',
        queryParameters:
            query != null && query.isNotEmpty ? {'keyword': query} : null,
      );

      if (response.statusCode == 200) {
        final List data = response.data;
        return data.map((json) => AudioBook.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  void _searchBooksFromApi(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchQuery = query;
        _audioBooksFuture = _loadAudioBooks(query: query);
      });
    });
  }

  Future<void> _refreshBooks() async {
    setState(() {
      _audioBooksFuture = _loadAudioBooks(query: searchQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        title: Text(
          'Audio Books',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: getRedColor(context),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        color: getRedColor(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchField(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildBookList(),
              ),
              SizedOverflowBox(size: const Size(0, 75)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: _searchBooksFromApi,
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: GoogleFonts.inter(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : const Color.fromARGB(116, 74, 83, 107),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  Widget _buildBookList() {
    return FutureBuilder<List<AudioBook>>(
      future: _audioBooksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingGrid();
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final books = snapshot.data ?? [];
        return _buildBookGrid(books);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.58,
        crossAxisSpacing: 12,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerBookCard();
      },
    );
  }

  Widget _buildShimmerBookCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Container(
                  height: 14,
                  width: 100,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: getRedColor(context)),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: getRedColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: getRedColor(context),
              foregroundColor: Colors.white,
            ),
            onPressed: () => setState(() {
              _audioBooksFuture = _loadAudioBooks(query: searchQuery);
            }),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No audiobooks found',
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          if (searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                _searchBooksFromApi('');
              },
              child: Text(
                'Clear search',
                style: TextStyle(color: getRedColor(context)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookGrid(List<AudioBook> books) {
    if (books.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.58,
        crossAxisSpacing: 12,
        mainAxisSpacing: 18,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          book: book,
          onTap: () => _navigateToBookDetails(book.identifier),
        );
      },
    );
  }

  void _navigateToBookDetails(String identifier) async {
    try {
      final response = await _dio.get(Uri.encodeComponent(identifier));

      if (response.statusCode == 200) {
        final data = response.data;
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioBookDetails(
              identifier: data['identifier'],
              // id: data['id'] ?? 0,
              title: data['title'],
              // author: data['creator'],
              // image: data['coverUrl'],
              // audioUrl: data['streamUrl'],
              creator: data['creator'],
              coverUrl: data['coverUrl'],
            ),
          ),
        );
      } else {
        throw Exception('Failed to load book details: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('Error loading book details: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to load book details'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _navigateToBookDetails(identifier),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Unexpected error: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    }
  }
}

class BookCard extends StatelessWidget {
  final AudioBook book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.grey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookCover(book),
            _buildBookInfo(book),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover(AudioBook book) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Image.network(
        book.coverImageUrl ?? '',
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            color: Colors.grey[200],
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
        errorBuilder: (context, error, stackTrace) => Container(
          height: 150,
          color: getTextColor(context),
          child: const Icon(Icons.broken_image, size: 50),
        ),
      ),
    );
  }

  Widget _buildBookInfo(AudioBook book) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            book.authorName,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
