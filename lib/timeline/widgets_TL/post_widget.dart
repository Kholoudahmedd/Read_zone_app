import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../icons_TL/comment_icon.dart';
import '../icons_TL/favourite_icon.dart';
import '../icons_TL/love_icon.dart';
import '../pages_TL/comment_page.dart';
import '../model_TL/api_service.dart';
import '../pages_TL/love_page.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;
  final VoidCallback onDelete;
  final ValueChanged<bool>? onFavoriteChanged; // 🔴 جديد

  const PostWidget({
    Key? key,
    required this.post,
    required this.onDelete,
    this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostModel post;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    loadLikeCount();
    loadCommentCount();
  }

  Future<void> loadLikeCount() async {
    try {
      final count = await ApiService.getPostLikeCount(post.id);
      setState(() {
        likeCount = count;
      });
    } catch (e) {
      print('❌ Error loading like count: $e');
    }
  }

  Future<void> loadCommentCount() async {
    try {
      final count = await ApiService.getPostCommentCount(post.id);
      setState(() {
        post.commentCount = count;
      });
    } catch (e) {
      print('❌ Error loading comment count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color cardColor = Theme.of(context).scaffoldBackgroundColor;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟢 عنوان البوست
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.profileImage != null
                      ? NetworkImage(post.profileImage!)
                      : null,
                  radius: 25,
                  backgroundColor: Colors.grey.shade300,
                  child: post.profileImage == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          post.timeAgo,
                          style: TextStyle(color: getTextColor(context)),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.public,
                            size: 16, color: getTextColor(context)),
                      ],
                    ),
                  ],
                ),
                Spacer(),

                // ✅ زر الحذف يظهر فقط إذا كان البوست خاص بالمستخدم الحالي
                post.isMine
                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Delete Confirmation"),
                              content: Text(
                                  "Are you sure you want to delete this post?"),
                              actions: [
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: Text("Delete"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final success =
                                await ApiService.deletePost(post.id);
                            if (success) {
                              widget.onDelete();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to delete post from server")),
                              );
                            }
                          }
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
            SizedBox(height: 10),

            if (post.postText.isNotEmpty)
              Text(
                post.postText,
                style: TextStyle(fontSize: 16, color: textColor),
              ),

            if (post.postImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    post.postImage!,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image),
                  ),
                ),
              ),

            // 🟢 صف التفاعل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    LoveIcon(
                      post: post,
                      onUpdate: () async {
                        await loadLikeCount();
                      },
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LovePage(post: post),
                          ),
                        );
                      },
                      child: Text(
                        likeCount.toString(),
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ],
                ),
                FavoriteIcon(
                  post: post,
                  onFavoriteChanged: (newStatus) {
                    setState(() {
                      post.isFavorited = newStatus;
                    });

                    // نبلغ الصفحة اللي فيها البوست إنه حصل تغيير
                    widget.onFavoriteChanged?.call(newStatus);
                  },
                ),
                Row(
                  children: [
                    CommentIcon(
                      onPressed: () async {
                        final updatedComments =
                            await Navigator.push<List<Commenter>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(post: post),
                          ),
                        );

                        if (updatedComments != null) {
                          setState(() {
                            post.commenters = updatedComments;
                          });
                          await loadCommentCount();
                        }
                      },
                    ),
                    SizedBox(width: 5),
                    Text(
                      (post.commentCount ?? 0).toString(),
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
