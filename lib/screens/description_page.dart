import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/themes/colors.dart';

class DescriptionPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const DescriptionPage({
    super.key,
    required this.bookId,
    required this.title,
    required this.author,
    required this.bookData,
  });

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
            _buildBookHeader(redColor),
            const SizedBox(height: 40),
            _buildSectionHeader('About the author', textColor),
            const SizedBox(height: 10),
            _buildAuthorInfo(),
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
            widget.title,
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
    String authorName = widget.author;
    String authorBio =
        '$authorName is a distinguished author known for their unique voice and deep insights into the human experience. Through years of writing, $authorName has crafted stories that resonate with readers around the world, offering both inspiration and reflection.';

    return Text(
      authorBio,
      style: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
      ),
    );
  }

  Widget _buildBookOverview() {
    String bookTitle = widget.title;
    String overview =
        '$bookTitle is a thought-provoking and emotionally engaging book that captures the essence of storytelling. It takes readers on a journey through vivid characters, rich plots, and powerful themes, making it a must-read for those who seek both entertainment and insight.';

    return Column(
      children: [
        Text(
          _isExpanded ? overview : '${overview.substring(0, 150)}...',
          style: GoogleFonts.inter(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        if (overview.length > 150)
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
