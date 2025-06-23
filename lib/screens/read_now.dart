import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/services/Api_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:dio/dio.dart';

class ReadNow extends StatefulWidget {
  final int bookId;
  final String title;
  final String author;

  const ReadNow({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
  });

  @override
  State<ReadNow> createState() => _ReadNowState();
}

class _ReadNowState extends State<ReadNow> {
  late ApiService2 _apiService;
  bool _isLoading = true;
  String _errorMessage = '';
  String _bookContent = '';

  @override
  void initState() {
    super.initState();
    _apiService = ApiService2(Dio());
    _fetchBookContent();
  }

  Future<void> _fetchBookContent() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final content =
          await _apiService.getBookContent(widget.bookId.toString());

      if (!mounted) return;

      setState(() {
        _bookContent = content.toString();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Error fetching content:\n${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Book header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.author,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildContent(),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _fetchBookContent,
      //   backgroundColor: getRedColor(context),
      //   tooltip: 'Refresh',
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: getRedColor(context)),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: getRedColor(context)),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: getRedColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchBookContent,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Text(
        _bookContent,
        style: GoogleFonts.inter(
          fontSize: 18,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
