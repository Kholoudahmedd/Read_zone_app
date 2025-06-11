import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/data/repos/home_rep_impl.dart';
import 'package:read_zone_app/services/Api_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/data/models/audiobook_model.dart';
import 'audio_book_details.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeDio();
    _audioBooksFuture = _loadAudioBooks();
  }

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://myfirstapi.runasp.net/api/',
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
      final result = await HomeRepoImpl(ApiService2(_dio)).fetchAudioBooks();
      return result.fold(
        (failure) => throw failure,
        (books) {
          if (query == null || query.isEmpty) return books;

          final lowerQuery = query.toLowerCase();

          // فلترة: يبدأ العنوان أو اسم الكاتب بالحرف الأول من البحث
          return books.where((book) {
            final titleStarts = book.title.toLowerCase().startsWith(lowerQuery);
            final authorStarts =
                book.authorName.toLowerCase().startsWith(lowerQuery);
            return titleStarts || authorStarts;
          }).toList();
        },
      );
    } catch (e) {
      debugPrint('Error loading books: $e');
      rethrow;
    }
  }

  void _searchBooksFromApi(String query) {
    setState(() {
      searchQuery = query;
      _audioBooksFuture = _loadAudioBooks(query: query);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
      body: Padding(
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
          return Center(
              child: CircularProgressIndicator(color: getRedColor(context)));
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final books = snapshot.data ?? [];
        return _buildBookGrid(books);
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error loading books',
              style:
                  GoogleFonts.inter(color: getRedColor(context), fontSize: 16)),
          const SizedBox(height: 8),
          Text(error,
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                setState(() => _audioBooksFuture = _loadAudioBooks()),
            child: Text('Retry', style: TextStyle(color: getRedColor(context))),
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
          Text('No audiobooks found',
              style: GoogleFonts.inter(fontSize: 18, color: Colors.grey[600])),
          if (searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                _searchBooksFromApi('');
              },
              child: const Text('Clear search'),
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
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(AudioBook book) {
    return GestureDetector(
      onTap: () => _navigateToBookDetails(book),
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
          color: Colors.grey[200],
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
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            book.authorName,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _navigateToBookDetails(AudioBook book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioBookDetails(
          id: book.id,
          title: book.title,
          author: book.authorName,
          image: book.coverImageUrl ?? '',
          audioUrl: book.audioUrl,
        ),
      ),
    );
  }
}
