// import 'package:flutter/material.dart';
// import 'notnotification.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   final List<Map<String, String>> notifications = const [
//     // لو عايزة تجربي الحالة الفاضية احذفي كل العناصر
//     {
//       'type': 'like',
//       'user': 'Aviril Children',
//       'message': 'Loved your post',
//       'time': '1m',
//       'image': 'https://randomuser.me/api/portraits/women/1.jpg',
//     },
//     {
//       'type': 'comment',
//       'user': 'Aviril Children',
//       'message': 'Commented on the status',
//       'time': '1m',
//       'image': 'https://randomuser.me/api/portraits/men/2.jpg',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
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
//         elevation: 0,
//         iconTheme: IconThemeData(color: likeColor),
//         title: Text(
//           'Notifications',
//           style: TextStyle(color: likeColor, fontSize: 25),
//         ),
//       ),
//       body: notifications.isEmpty
//           ? const NoNotificationPage()
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final notif = notifications[index];
//                 final isLike = notif['type'] == 'like';

//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isLike ? likeColor : commentColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: isLike ? Colors.white : Colors.grey,
//                         child: Icon(
//                           isLike ? Icons.favorite : Icons.comment,
//                           color: isLike ? Colors.black : Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: '${notif['user']} ',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: notif['message'],
//                                     style: TextStyle(color: textColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               notif['time']!,
//                               style: TextStyle(
//                                 color: subTextColor,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       CircleAvatar(
//                         backgroundImage: NetworkImage(notif['image']!),
//                         radius: 20,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'notnotification.dart';

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<Map<String, String>> notifications = [
//       // لو عايزة تجربي الحالة الفاضية احذفي كل العناصر دي
//       {
//         'type': 'like',
//         'user': 'Aviril Children',
//         'message': 'Loved your post',
//         'time': '1m',
//         'image': 'https://randomuser.me/api/portraits/women/1.jpg',
//       },
//       {
//         'type': 'comment',
//         'user': 'Aviril Children',
//         'message': 'Commented on the status',
//         'time': '1m',
//         'image': 'https://randomuser.me/api/portraits/men/2.jpg',
//       },
//     ];

//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
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
//         elevation: 0,
//         iconTheme: IconThemeData(color: likeColor),
//         title: Text(
//           'Notifications',
//           style: TextStyle(color: likeColor, fontSize: 25),
//         ),
//       ),
//       body: notifications.isEmpty
//           ? const NoNotificationPage()
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final notif = notifications[index];
//                 final isLike = notif['type'] == 'like';

//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isLike ? likeColor : commentColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: isLike ? Colors.white : Colors.grey,
//                         child: Icon(
//                           isLike ? Icons.favorite : Icons.comment,
//                           color: isLike ? Colors.black : Colors.white,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text.rich(
//                               TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: '${notif['user']} ',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: textColor,
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: notif['message'],
//                                     style: TextStyle(color: textColor),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               notif['time']!,
//                               style: TextStyle(
//                                 color: subTextColor,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       CircleAvatar(
//                         backgroundImage: NetworkImage(notif['image']!),
//                         radius: 20,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'notnotification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      // {
      //   'type': 'like',
      //   'user': 'Aviril Children',
      //   'message': 'Loved your post',
      //   'time': '1m',
      //   'image': 'https://randomuser.me/api/portraits/women/1.jpg',
      // },
      // {
      //   'type': 'comment',
      //   'user': 'Aviril Children',
      //   'message': 'Commented on the status',
      //   'time': '1m',
      //   'image': 'https://randomuser.me/api/portraits/men/2.jpg',
      // },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
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
        title: Row(
          children: [
            Icon(Icons.notifications, color: likeColor),
            const SizedBox(width: 8),
            Text(
              'Notifications',
              style: TextStyle(color: likeColor, fontSize: 25),
            ),
          ],
        ),
      ),
      body:
          notifications.isEmpty
              ? const NoNotificationPage()
              : ListView.builder(
                padding: const EdgeInsets.all(16),
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
                          backgroundColor: isLike ? Colors.white : Colors.grey,
                          child: Icon(
                            isLike ? Icons.favorite : Icons.comment,
                            color: isLike ? Colors.black : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${notif['user']} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: notif['message'],
                                      style: TextStyle(color: textColor),
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
                          backgroundImage: NetworkImage(notif['image']!),
                          radius: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
