// timeline_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:read_zone_app/services/auth_service.dart';
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
  String? username;
  String? email;
  String? userImage;
  final String baseUrl = 'https://myfirstapi.runasp.net/';

  @override
  void initState() {
    super.initState();
    loadPosts();
    loadUserProfile();
  }

  void loadUserProfile() async {
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
      });
    } else {
      print("ERROR: Failed to load user profile");
    }
  }

  Future<void> loadPosts() async {
    setState(() => isLoading = true);
    final fetchedPosts = await ApiService.fetchPosts();
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
        loadPosts(); // ✅ نعيد التحميل بعد الرجوع
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage:
                      (userImage != null && userImage!.startsWith('http'))
                          ? NetworkImage(userImage!)
                          : const AssetImage('assets/images/test.jpg')
                              as ImageProvider,
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
                    child:
                        CircularProgressIndicator(color: getRedColor(context)))
                : RefreshIndicator(
                    color: getRedColor(context),
                    onRefresh: loadPosts, // ✅ تحديث عند السحب
                    child: posts.isEmpty
                        ? Center(
                            child: Text("No posts available at the moment"))
                        : ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return PostWidget(
                                post: post,
                                onDelete: () async {
                                  setState(() {
                                    posts.removeAt(index);
                                  });
                                  await loadPosts(); // ✅ إعادة التحميل بعد الحذف
                                },
                              );
                            },
                          ),
                  ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
