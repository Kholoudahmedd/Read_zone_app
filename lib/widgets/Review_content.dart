import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:readmore/readmore.dart';

class ReviewContent extends StatelessWidget {
  final int reviewId; // مضاف لربط الزر بحذف المراجعة من API
  final String currentUsername;
  final String userName;
  final String profileImage;
  final String reviewText;
  final double rating;
  final DateTime time;
  final VoidCallback onDelete;

  const ReviewContent({
    super.key,
    required this.reviewId,
    required this.currentUsername,
    required this.userName,
    required this.profileImage,
    required this.reviewText,
    required this.rating,
    required this.time,
    required this.onDelete,
  });

  String formatTime(DateTime reviewTime) {
    try {
      final diff = DateTime.now().difference(reviewTime);
      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hrs ago";
      if (diff.inDays < 7) return "${diff.inDays} days ago";
      if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} weeks ago";
      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} months ago";
      return "${(diff.inDays / 365).floor()} years ago";
    } catch (_) {
      return "Unknown time";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        userName.toLowerCase() == currentUsername.toLowerCase();
    final imageProvider = profileImage.isNotEmpty
        ? NetworkImage('https://myfirstapi.runasp.net/$profileImage')
        : const AssetImage('assets/images/test.jpg') as ImageProvider;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: getRedColor(context),
                backgroundImage: imageProvider,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userName,
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (_, __) =>
                            Icon(Iconsax.star1, color: getRedColor(context)),
                        itemCount: 5,
                        rating: rating,
                        itemSize: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(formatTime(time),
                          style: GoogleFonts.inter(fontSize: 15)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: getRedColor(context)),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ReadMoreText(
              reviewText,
              trimLines: 2,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          Divider(thickness: 1, color: Colors.grey[600]),
        ],
      ),
    );
  }
}
