// import 'dart:io';
// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../widgets_TL/post_widget.dart';
// import '../widgets_TL/image_picker.dart';
// import '../pages_TL/create_post.dart';
// import '../model_TL/api_service.dart';

// class TimelinePage extends StatefulWidget {
//   @override
//   _TimelinePageState createState() => _TimelinePageState();
// }

// class _TimelinePageState extends State<TimelinePage> {
//   List<PostModel> posts = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadPosts();
//   }

//   Future<void> loadPosts() async {
//     final fetchedPosts = await ApiService.fetchPosts(); // ✅ من API
//     setState(() {
//       posts = fetchedPosts;
//       isLoading = false;
//     });
//   }

//   // void handleImagePicked(File? image) {
//   //   if (image != null) {
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => CreatePostPage(selectedImage: image),
//   //       ),
//   //     ).then((value) {
//   //       if (value == true) {
//   //         loadPosts(); // ✅ نعيد تحميل البوستات من API بعد الإضافة
//   //       }
//   //     });
//   //   }
//   // }
//   void handleImagePicked(File? image) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreatePostPage(selectedImage: image),
//       ),
//     ).then((value) {
//       if (value == true) {
//         loadPosts(); // نعيد تحميل البوستات بعد الإضافة
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userData = {
//       'userName': 'Local User',
//       'userEmail': 'local@example.com',
//       'userImage': 'assets/images/test.jpg',
//     };

//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 10),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//             decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 1,
//                   spreadRadius: 1,
//                   offset: Offset(0, -2),
//                 ),
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   spreadRadius: 2,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: AssetImage(userData['userImage']!),
//                   radius: 25,
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => handleImagePicked(null),
//                     child: Container(
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(25),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 8,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         "What's on your mind?",
//                         style: TextStyle(color: Colors.grey[600], fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ImagePickerWidget(onImagePicked: handleImagePicked),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator()) // تحميل
//                 : posts.isEmpty
//                     ? Center(child: Text("No posts available at the moment"))
//                     : ListView.builder(
//                         itemCount: posts.length,
//                         itemBuilder: (context, index) {
//                           final post = posts[index];
//                           return PostWidget(
//                             post: post,
//                             onDelete: () async {
//                               final deleted =
//                                   await ApiService.deletePost(post.id);
//                               if (deleted) {
//                                 setState(() {
//                                   posts.removeAt(index);
//                                 });
//                               } else {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("فشل حذف المنشور")),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),
//           ),
//           SizedBox(height: 100),
//         ],
//       ),
//     );
//   }
// }
//اخر حاجة

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../widgets_TL/post_widget.dart';
import '../widgets_TL/image_picker.dart';
import '../pages_TL/create_post.dart';
import '../model_TL/api_service.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<PostModel> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final fetchedPosts = await ApiService.fetchPosts(); // ✅ من API
    setState(() {
      posts = fetchedPosts;
      isLoading = false;
    });
  }

  void handleImagePicked(File? image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostPage(selectedImage: image),
      ),
    ).then((value) {
      if (value == true) {
        loadPosts(); // ✅ نعيد تحميل البوستات بعد الإضافة
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = {
      'userName': 'Local User',
      'userEmail': 'local@example.com',
      'userImage': 'assets/images/test.jpg',
    };

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: Offset(0, -2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(userData['userImage']!),
                  radius: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => handleImagePicked(null),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        "What's on your mind?",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ImagePickerWidget(onImagePicked: handleImagePicked),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: getRedColor(context),
                  )) // تحميل
                : posts.isEmpty
                    ? Center(child: Text("No posts available at the moment"))
                    : ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return PostWidget(
                            post: post,
                            onDelete: () {
                              // ✅ نحذف من الواجهة مباشرة بدون نداء API هنا
                              setState(() {
                                posts.removeAt(index);
                              });
                            },
                          );
                        },
                      ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
