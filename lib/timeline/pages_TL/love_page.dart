import 'package:flutter/material.dart';
import '../model_TL/model_post.dart';

class LovePage extends StatelessWidget {
  final PostModel post;

  const LovePage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // إضافة صورة المستخدم الحالي إلى بداية قائمة "Loved Users" إذا كان قد قام بـ "Love"
    if (post.isLoved && !post.lovedUsers.contains(currentUser)) {
      post.lovedUsers.insert(0, currentUser);
    }

    return Scaffold(
      appBar: AppBar(title: Text('People Who Loved This Post')),
      body:
          post.lovedUsers.isEmpty
              ? Center(child: Text('No one has loved this post yet.'))
              : ListView.builder(
                itemCount: post.lovedUsers.length,
                itemBuilder: (context, index) {
                  final user = post.lovedUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Stack(
                          clipBehavior:
                              Clip.none, // لمنع قص الأيقونات الخارجة عن حدود الصورة
                          children: [
                            // صورة المستخدم
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(user.profileImage),
                            ),
                            Positioned(
                              bottom: -3,
                              right: -3,
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 31,
                              ),
                            ),
                            // أيقونة القلب في أسفل الصورة
                            Positioned(
                              bottom: -1,
                              right: -1,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Text(user.username, style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
