import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:read_zone_app/Notfication/notification_ser.dart';
import 'package:read_zone_app/Notfication/notfication_details.dart';
import 'package:read_zone_app/timeline/model_TL/api_service.dart';
import '../main.dart';

class NotificationMonitor {
  Timer? _timer;
  final box = GetStorage();
  List<int> _seenNotificationIds = [];

  void start() {
    // ⬇️ تحميل الإشعارات اللي اتعرضت قبل كده من GetStorage
    _seenNotificationIds =
        List<int>.from(box.read<List>('seenNotificationIds') ?? []);

    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      try {
        final notifications = await NotificationService().fetchNotifications();

        // ⬇️ الإشعارات الجديدة فقط
        final newNotifications = notifications
            .where((n) => !_seenNotificationIds.contains(n.id))
            .toList();

        if (newNotifications.isNotEmpty) {
          for (final notification in newNotifications) {
            await _showNotification(notification);

            // ⬇️ حفظ معرف الإشعار على إنه اتعرض
            _seenNotificationIds.add(notification.id);
            box.write('seenNotificationIds', _seenNotificationIds);

            // ⬇️ علّم الإشعار إنه مقروء
            await NotificationService().markAsRead(notification.id);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      } catch (e) {
        print('❌ Error checking notifications: $e');
      }
    });
  }

  Future<void> _showNotification(NotificationModel notification) async {
    final isLike = notification.type.toLowerCase() == 'like';
    final icon = isLike ? Icons.favorite : Icons.comment;
    final iconColor =
        isLike ? const Color(0xffC86B60) : const Color(0xff3A6F73);
    final bgColor = iconColor.withOpacity(0.1);
    final title = isLike ? 'New Like ❤️' : 'New Comment 💬';
    final action = isLike ? 'liked' : 'commented on';

    Get.snackbar(
      title,
      '',
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Get.isDarkMode ? Colors.white : Colors.black87,
              ),
              children: [
                TextSpan(
                  text: notification.sourceUsername,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' $action your post'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(DateTime.parse(notification.createdAt)),
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      shouldIconPulse: true,
      barBlur: 15,
      isDismissible: true,
      backgroundColor: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
      colorText: Get.isDarkMode ? Colors.white : Colors.black,
      snackPosition: SnackPosition.TOP,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 5),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ],
      mainButton: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: iconColor.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'VIEW',
          style: TextStyle(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _handleNotificationTap(notification),
      ),
      onTap: (_) => _handleNotificationTap(notification),
    );
  }

  Future<void> _handleNotificationTap(NotificationModel notification) async {
    try {
      if (notification.postId == null) return;

      final post = await ApiService.getPostById(notification.postId!);
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(
            builder: (_) => NotificationDetails(post: post),
          ),
        );
      }
    } catch (e) {
      print('❌ Error loading post: $e');
      Get.snackbar(
        'Error',
        'Could not open the post',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  void stop() {
    _timer?.cancel();
  }
}
