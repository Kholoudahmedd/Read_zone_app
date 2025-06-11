import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;

  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();
  bool _showEmojiPicker = false;

  // دالة لإضافة تعليق جديد
  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      final newComment = Commenter(
        username: currentUser.username,
        profileImage: currentUser.profileImage,
        commentText: _commentController.text,
      );

      setState(() {
        widget.post.addComment(_commentController.text, newComment);
      });

      _commentController.clear(); // مسح النص بعد الإضافة
    }
  }

  // دالة لعرض أو إخفاء لوحة الإيموجي
  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // عرض التعليقات
            Expanded(
              child: ListView.builder(
                itemCount: widget.post.commenters.length,
                itemBuilder: (context, index) {
                  final commenter = widget.post.commenters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(commenter.profileImage),
                          radius: 20,
                        ),
                        SizedBox(width: 10), // مسافة بين الصورة والنص
                        //  التعليق يأخذ طول النص فقط
                        Container(
                          padding: EdgeInsets.all(12),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: getRedColor(context),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // اسم المستخدم
                              Text(
                                commenter.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 5),
                              // نص التعليق
                              Text(
                                commenter.commentText,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // حقل لإضافة تعليق جديد
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment",
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min, // لضبط الحجم
                          children: [
                            //ايقونة ايموجي
                            IconButton(
                              icon: Icon(Icons.emoji_emotions_outlined),
                              onPressed: _toggleEmojiPicker,
                            ),
                            //أيقونة إرسال داخل تعليق
                            IconButton(
                              icon: Icon(
                                Icons.send,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              onPressed: _addComment,
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // إظهار لوحة الإيموجي
            if (_showEmojiPicker)
              EmojiPicker(
                onEmojiSelected: (category, Emoji) {
                  setState(() {
                    _commentController.text += Emoji.emoji;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
