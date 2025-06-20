import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../model_TL/api_service.dart';
import 'package:get_storage/get_storage.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;

  const CommentPage({Key? key, required this.post}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();
  bool _showEmojiPicker = false;
  List<Commenter> comments = [];
  String? currentUserImage;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _loadCurrentUserImage();
  }

  Future<void> _loadCurrentUserImage() async {
    // استرجاع رابط صورة المستخدم الحالي من التخزين
    final image = GetStorage().read('profileImage');
    if (image != null && image != 'string') {
      setState(() {
        currentUserImage = 'https://myfirstapi.runasp.net$image';
      });
    }
  }

  Future<void> _fetchComments() async {
    final fetchedComments = await ApiService.getComments(widget.post.id);
    setState(() {
      comments = fetchedComments;
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final success = await ApiService.addComment(
      postId: widget.post.id,
      commentText: text,
    );

    if (success) {
      _commentController.clear();
      await _fetchComments();
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, comments);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Comments"),
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context, comments);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // عرض التعليقات
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final commenter = comments[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: commenter.profileImage != null
                                ? NetworkImage(commenter.profileImage!)
                                : null,
                            radius: 20,
                            backgroundColor: Colors.grey.shade300,
                            child: commenter.profileImage == null
                                ? Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: getRedColor(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  commenter.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 5),
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
                    CircleAvatar(
                      backgroundImage: currentUserImage != null
                          ? NetworkImage(currentUserImage!)
                          : null,
                      radius: 18,
                      backgroundColor: Colors.grey.shade300,
                      child: currentUserImage == null
                          ? Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Add a comment",
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.emoji_emotions_outlined),
                                onPressed: _toggleEmojiPicker,
                              ),
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
                              vertical: 10, horizontal: 15),
                          fillColor:
                              Theme.of(context).inputDecorationTheme.fillColor,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (_showEmojiPicker)
                EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _commentController.text += emoji.emoji;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
