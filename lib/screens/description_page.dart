import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/themes/colors.dart';

class DescriptionPage extends StatefulWidget {
  final int bookId;
  final String title;
  final String author;

  const DescriptionPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
  });

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  // bool _isExpanded = false;
  bool _isLoading = true;
  String? _summary;
  String? _title;
  String? _author;

  final Dio _dio = Dio();
  final String baseUrl =
      'https://myfirstapi.runasp.net/api/Books'; // عدّل هذا إلى رابط API الحقيقي

  @override
  void initState() {
    super.initState();
    _fetchBookDetails();
  }

  Future<void> _fetchBookDetails() async {
    try {
      final response = await _dio.get('$baseUrl/details/${widget.bookId}');
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _title = data['title'];
          _author = data['authorName'];
          _summary = data['summary'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load book');
      }
    } catch (e) {
      setState(() {
        _summary = 'failed to load summary';
        _title = widget.title;
        _author = widget.author;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor2(context);
    final redColor = getRedColor(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBookHeader(redColor),
                  const SizedBox(height: 10),
                  // _buildSectionHeader('About the author', textColor),
                  // const SizedBox(height: 10),
                  // _buildAuthorInfo(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('Overview', textColor),
                  const SizedBox(height: 10),
                  _buildBookOverview(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildBookHeader(Color color) {
    return Center(
      child: Column(
        children: [
          Text(
            _title ?? widget.title,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            _author ?? widget.author,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  // Widget _buildAuthorInfo() {
  //   String authorName = _author ?? widget.author;
  //   String authorBio =
  //       '$authorName is a distinguished author known for their unique voice and deep insights into the human experience. Through years of writing, $authorName has crafted stories that resonate with readers around the world, offering both inspiration and reflection.';

  //   return Text(
  //     authorBio,
  //     style: GoogleFonts.inter(
  //       fontSize: 14,
  //       height: 1.5,
  //     ),
  //   );
  // }

  Widget _buildBookOverview() {
    String overview = _summary ?? 'No overview available for this book.';
    return Column(
      children: [
        Text(
          overview,
          style: GoogleFonts.inter(
            color: getTextColor2(context),
            fontWeight: FontWeight.bold,
            fontSize: 16,

          ),
        ),
      ],
    );
  }
}
