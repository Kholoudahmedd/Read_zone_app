import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:read_zone_app/services/auth_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:readmore/readmore.dart';

class ReviewContent extends StatefulWidget {
  final String userName;
  final String reviewText;
  final double rating;
  final DateTime time;
  final String profileImage;
  final VoidCallback onDelete;

  const ReviewContent({
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.time,
    required this.profileImage,
    required this.onDelete,
    super.key,
  });

  @override
  State<ReviewContent> createState() => _ReviewContentState();
}

class _ReviewContentState extends State<ReviewContent> {
  String? username;
  String? email;
  String? userImage;
  bool isLoading = true;
  final storage = GetStorage();

  final String baseUrl = 'https://myfirstapi.runasp.net/';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final authService = AuthService();
    final profile = await authService.getProfile();

    if (!mounted) return;

    if (profile != null) {
      final profileImage = profile['profileImageUrl'];
      setState(() {
        username = profile['username'];
        email = profile['email'];
        userImage = profileImage != null && profileImage != ''
            ? '$baseUrl$profileImage'
            : null;
        isLoading = false;
      });
    } else {
      print("ERROR: Failed to load user profile");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatTime(DateTime reviewTime) {
    try {
      Duration diff = DateTime.now().difference(reviewTime);
      if (diff.inSeconds < 60) return "Just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
      if (diff.inHours < 24) return "${diff.inHours} hrs ago";
      if (diff.inDays < 7) return "${diff.inDays} days ago";
      if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} weeks ago";
      if (diff.inDays < 365) return "${(diff.inDays / 30).floor()} months ago";
      return "${(diff.inDays / 365).floor()} years ago";
    } catch (e) {
      return "Unknown time";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        widget.userName.toLowerCase() == (username?.toLowerCase() ?? '');
    final displayedImage = isCurrentUser && userImage != null
        ? NetworkImage(userImage!)
        : AssetImage('assets/images/test.jpg') as ImageProvider;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: getRedColor(context),
                backgroundImage: displayedImage,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName,
                      style: GoogleFonts.inter(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      RatingBarIndicator(
                        itemBuilder: (_, __) =>
                            Icon(Iconsax.star1, color: getRedColor(context)),
                        itemCount: 5,
                        rating: widget.rating,
                        itemSize: 15,
                      ),
                      SizedBox(width: 5),
                      Text(formatTime(widget.time),
                          style: GoogleFonts.inter(fontSize: 15)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              if (isCurrentUser)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') widget.onDelete();
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
                  icon: Icon(Icons.more_vert),
                ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ReadMoreText(
              widget.reviewText,
              trimLines: 2,
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          Divider(thickness: 1),
        ],
      ),
    );
  }
}
