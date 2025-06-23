import 'package:flutter/material.dart';
import 'package:read_zone_app/Notfication/notfication_details.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../Notfication/notification_ser.dart';
import 'notnotification.dart';
import '../timeline/widgets_TL/time.dart';
import '../timeline/model_TL/api_service.dart'; // استيراد ApiService

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _service = NotificationService();
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _service.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final likeColor = const Color(0xFFFF9A8C);
    final commentColor = const Color(0xFF4A536B);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: getRedColor(context)),
        title: Row(
          children: [
            Icon(Icons.notifications, color: getRedColor(context), size: 30),
            const SizedBox(width: 8),
            Text(
              'Notification',
              style: TextStyle(
                  color: getRedColor(context),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: getRedColor(context)),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data!;
          if (notifications.isEmpty) {
            return const NoNotificationPage();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final isLike = notif.type.toLowerCase() == 'like';
              final Color baseColor = isLike ? likeColor : commentColor;
              final Color cardColor = baseColor.withOpacity(0.15);

              return GestureDetector(
                onTap: () async {
                  try {
                    final post = await ApiService.getPostById(notif.postId!);
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationDetails(post: post),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Post not found")),
                      );
                    }
                  } catch (e) {
                    print("Error loading post: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to load post")),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          isLike
                              ? Icons.favorite_border
                              : Icons.mode_comment_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: notif.sourceUsername,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: isLike
                                        ? ' Loved your post'
                                        : ' Commented on the status',
                                    style: TextStyle(
                                        color: subTextColor, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatTime(DateTime.parse(notif.createdAt)),
                              style:
                                  TextStyle(color: subTextColor, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              _getProfileImage(notif.sourceProfileImageUrl),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  ImageProvider _getProfileImage(String url) {
    if (url.isEmpty || url == 'string') {
      return const AssetImage('assets/images/test.jpg');
    }

    if (!url.startsWith('http')) {
      return NetworkImage('https://myfirstapi.runasp.net$url');
    }

    return NetworkImage(url);
  }
}
