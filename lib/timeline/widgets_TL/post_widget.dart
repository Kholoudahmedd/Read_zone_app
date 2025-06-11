import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../icons_TL/comment_icon.dart'; // أيقونة التعليق
import '../icons_TL/favourite_icon.dart'; // أيقونة المفضلة
import '../icons_TL/love_icon.dart'; // أيقونة الإعجاب
import '../pages_TL/comment_page.dart'; // استيراد صفحة التعليقات

class PostWidget extends StatefulWidget {
  final PostModel post;
  final VoidCallback onDelete;

  const PostWidget({Key? key, required this.post, required this.onDelete})
      : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late PostModel post;

  @override
  void initState() {
    super.initState();
    post = widget.post; // تخزين بيانات البوست
  }

  // تبديل حالة الإعجاب
  void toggleLove() {
    setState(() {
      post.toggleLove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color cardColor = Theme.of(context).scaffoldBackgroundColor;
    final Color secondaryColor = Theme.of(context).secondaryHeaderColor;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  الجزء العلوي: صورة البروفايل، الاسم، الوقت، وأيقونة الحذف
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.profileImage),
                  radius: 25,
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
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    widget.onDelete();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // محتوي البوست (صورة +نص)
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
                  child: Image.asset(
                    post.postImage!,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),

            //   (إعجاب - مفضلة - تعليق)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: toggleLove, // تفعيل الإعجاب عند النقر
                      child: LoveIcon(post: post),
                    ),
                  ],
                ),
                Row(children: [FavoriteIcon(post: post), SizedBox(width: 5)]),
                Row(
                  children: [
                    CommentIcon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(post: post),
                          ),
                        );
                        setState(() {}); // تحديث الواجهة بعد التعليق
                      },
                    ),
                    SizedBox(width: 5),
                    Text(
                      post.commenters.length.toString(),
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
