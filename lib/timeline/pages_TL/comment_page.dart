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

  bool isLoadingComments = true;
  bool isSendingComment = false;

  @override
  void initState() {
    super.initState();
    _fetchComments();
    _loadCurrentUserImage();
  }

  Future<void> _loadCurrentUserImage() async {
    final image = GetStorage().read('profileImage');
    if (image != null && image != 'string') {
      setState(() {
        currentUserImage = 'https://myfirstapi.runasp.net$image';
      });
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      isLoadingComments = true;
    });
    final fetchedComments = await ApiService.getComments(widget.post.id);
    setState(() {
      comments = fetchedComments;
      isLoadingComments = false;
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isSendingComment = true;
    });

    final success = await ApiService.addComment(
      postId: widget.post.id,
      commentText: text,
    );

    if (success) {
      _commentController.clear();
      await _fetchComments();
    }

    setState(() {
      isSendingComment = false;
    });
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
              Expanded(
                child: isLoadingComments
                    ? Center(
                        child: CircularProgressIndicator(
                        color: getRedColor(context),
                      ))
                    : comments.isEmpty
                        ? Text("No comments yet.")
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final commenter = comments[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade300,
                                      child: ClipOval(
                                        child: commenter.profileImage != null &&
                                                commenter.profileImage!
                                                    .startsWith('http')
                                            ? Image.network(
                                                commenter.profileImage!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/images/test.jpg',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                'assets/images/test.jpg',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getRedColor(context),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.emoji_emotions_outlined),
                                onPressed: _toggleEmojiPicker,
                              ),
                              isSendingComment
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: getRedColor(context),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.send,
                                        color: getRedColor(context),
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
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: getRedColor(context),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    )
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
