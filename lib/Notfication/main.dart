import 'package:flutter/material.dart';

import 'notnotification.dart';

void main() {
  runApp(const NotificationApp());
}

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  // تحكم هنا بالثيم: true = داكن، false = فاتح
  final bool isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: NotificationScreen(isDark: isDark),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final bool isDark;

  NotificationScreen({super.key, required this.isDark});

  final List<Map<String, String>> notifications = [
    // جرب تحذف العناصر هنا علشان تشوف صفحة no notification
    {
      'type': 'like',
      'user': 'Aviril Children',
      'message': 'Loved your post',
      'time': '1m',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'type': 'comment',
      'user': 'Aviril Children',
      'message': 'Commented on the status',
      'time': '1m',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'type': 'like',
      'user': 'Aviril Children',
      'message': 'Loved your post',
      'time': '1m',
      'image': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'type': 'comment',
      'user': 'Aviril Children',
      'message': 'Commented on the status',
      'time': '1m',
      'image': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ألوان حسب الثيم
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final likeColor =
        isDark ? const Color(0xFFDA7264) : const Color(0xffFF9A8C);
    final commentColor =
        isDark ? const Color(0xFF1F2630) : const Color(0xff4A536B);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: likeColor),
        leading: IconButton(
          icon: const Icon(Icons.notifications_active, size: 40),
          onPressed: () {},
          
        ),
        title: Text(
          'Notification',
          style: TextStyle(color: likeColor, fontSize: 25),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16), // مسافة تحت الـ AppBar

            Expanded(
              child:
                  notifications.isEmpty
                      ? const NoNotificationPage() // لو مفيش إشعارات يعرض الصفحة دي
                      : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          final isLike = notif['type'] == 'like';
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isLike ? likeColor : commentColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      isLike ? Colors.white : Colors.grey,
                                  child: Icon(
                                    isLike ? Icons.favorite : Icons.comment,
                                    color: isLike ? Colors.black : Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: notif['user']! + ' ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: notif['message'],
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notif['time']!,
                                        style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    notif['image']!,
                                  ),
                                  radius: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}


//api
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'notnotification.dart'; // صفحة لا إشعارات

// void main() {
//   runApp(const NotificationApp());
// }

// class NotificationApp extends StatelessWidget {
//   const NotificationApp({super.key});

//   final bool isDark = true;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: isDark ? ThemeData.dark() : ThemeData.light(),
//       home: NotificationScreen(isDark: isDark),
//     );
//   }
// }

// class NotificationScreen extends StatefulWidget {
//   final bool isDark;

//   const NotificationScreen({super.key, required this.isDark});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   List notifications = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   Future<void> fetchNotifications() async {
//     final url = Uri.parse(
//       'https://myfirstapi.runasp.net/api/Timeline/notifications',
//     );
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List data = json.decode(response.body);
//         setState(() {
//           notifications = data;
//           isLoading = false;
//         });
//       } else {
//         setState(() => isLoading = false);
//         print('Failed to load notifications');
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//       print('Error: $e');
//     }
//   }

//   Future<void> markAsRead(int notificationId) async {
//     final url = Uri.parse(
//       'https://myfirstapi.runasp.net/api/Timeline/notifications/$notificationId/read',
//     );
//     try {
//       final response = await http.post(url);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         fetchNotifications();
//       } else {
//         print('Failed to mark notification as read');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = widget.isDark;
//     final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
//     final likeColor =
//         isDark ? const Color(0xFFDA7264) : const Color(0xffFF9A8C);
//     final commentColor =
//         isDark ? const Color(0xFF1F2630) : const Color(0xff4A536B);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final subTextColor = isDark ? Colors.white70 : Colors.black54;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: const [
//             SizedBox(width: 12),
//             Icon(Icons.notifications_active, color: Colors.white),
//             SizedBox(width: 8),
//             Text(
//               'Notification',
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ],
//         ),
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : notifications.isEmpty
//               ? const NoNotificationPage()
//               : ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: notifications.length,
//                 itemBuilder: (context, index) {
//                   final notif = notifications[index];
//                   final int id = notif['id'] ?? 0;
//                   final String type = notif['type'] ?? 'like';
//                   final String user = notif['user'] ?? 'Unknown';
//                   final String message = notif['message'] ?? '';
//                   final String time = notif['time'] ?? 'Now';
//                   final String image =
//                       notif['image'] ??
//                       'https://randomuser.me/api/portraits/lego/1.jpg';

//                   final isLike = type == 'like';

//                   return GestureDetector(
//                     onTap: () => markAsRead(id),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: isLike ? likeColor : commentColor,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor:
//                                 isLike ? Colors.white : Colors.grey,
//                             child: Icon(
//                               isLike ? Icons.favorite : Icons.comment,
//                               color: isLike ? Colors.black : Colors.white,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: '$user ',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: textColor,
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: message,
//                                         style: TextStyle(color: textColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   time,
//                                   style: TextStyle(
//                                     color: subTextColor,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           CircleAvatar(
//                             backgroundImage: NetworkImage(image),
//                             radius: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }