import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/themes/colors.dart';

class DescriptionPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const DescriptionPage(
      {super.key,
      required this.bookId,
      required this.title,
      required this.author,
      required this.bookData});
  final int bookId;
  final String title;
  final String author;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor2(context);
    final redColor = getRedColor(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Book Title and Author
            _buildBookHeader(redColor),
            const SizedBox(height: 40),
            // About the Author Section
            _buildSectionHeader('About the author', textColor),
            const SizedBox(height: 10),
            _buildAuthorInfo(),
            const SizedBox(height: 30),
            // Overview Section
            _buildSectionHeader('Overview', textColor),
            const SizedBox(height: 10),
            _buildBookOverview(),
            const SizedBox(height: 30),
            // Additional Info Section
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
            widget.title,
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.author,
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

  Widget _buildAuthorInfo() {
    return Text(
      widget.bookData['authorBio'] ?? 'No author information available.',
      style: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildBookOverview() {
    return Column(
      children: [
        Text(
          _isExpanded
              ? widget.bookData['description'] ?? 'No description available.'
              : '${widget.bookData['description']?.substring(0, 150) ?? 'No description available.'}...',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if ((widget.bookData['description']?.length ?? 0) > 150)
          TextButton(
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              _isExpanded ? 'Show less' : 'Read more',
              style: GoogleFonts.inter(
                color: getRedColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
