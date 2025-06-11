import 'package:flutter/material.dart';
import 'dart:io';
import '../model_TL/model_post.dart';
import '../widgets_TL/post_widget.dart';
import '../widgets_TL/image_picker.dart';
import '../pages_TL/create_post.dart';

class TimelinePage extends StatefulWidget {
  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<PostModel> posts = [];

  @override
  void initState() {
    super.initState();
    posts = List.from(dummyPosts); // استخدام بيانات محلية فقط
  }

  void navigateToCreatePost([File? image]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostPage(selectedImage: image),
      ),
    );

    if (result == true) {
      setState(() {
        posts = List.from(dummyPosts); // إعادة تحميل البيانات المحلية
      });
    }
  }

  void handleImagePicked(File? image) {
    if (image != null) {
      navigateToCreatePost(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    // بيانات المستخدم ثابتة ومحلية
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
                    onTap: () => navigateToCreatePost(),
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
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostWidget(
                  post: post,
                  onDelete: () {
                    setState(() {
                      posts.removeWhere((p) => p.id == post.id);
                      dummyPosts.removeWhere((p) => p.id == post.id);
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
