import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:read_zone_app/timeline/icons_TL/favourite_icon.dart';
import 'package:read_zone_app/timeline/icons_TL/love_icon.dart';
import 'package:read_zone_app/timeline/model_TL/model_post.dart';
import 'package:read_zone_app/timeline/widgets_TL/time.dart';
import '../../themes/colors.dart';
import '../timeline/model_TL/api_service.dart';

class NotificationDetails extends StatefulWidget {
  final PostModel post;

  const NotificationDetails({super.key, required this.post});

  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  late PostModel post;
  int likeCount = 0;
  List<Commenter> comments = [];
  TextEditingController _commentController = TextEditingController();
  bool _showEmojiPicker = false;
  String? currentUserImage;

  bool isLoadingComments = true;
  bool isSendingComment = false;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _loadLikeCount();
    _loadCommentCount();
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

  Future<void> _loadLikeCount() async {
    final count = await ApiService.getPostLikeCount(post.id);
    setState(() {
      likeCount = count;
    });
  }

  Future<void> _loadCommentCount() async {
    final count = await ApiService.getPostCommentCount(post.id);
    setState(() {
      post.commentCount = count;
    });
  }

  Future<void> _fetchComments() async {
    setState(() {
      isLoadingComments = true;
    });
    final fetched = await ApiService.getComments(post.id);
    setState(() {
      comments = fetched;
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
      postId: post.id,
      commentText: text,
    );

    if (success) {
      _commentController.clear();
      await _fetchComments();
      await _loadCommentCount();
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
    final Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color cardColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: getRedColor(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: cardColor,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade300,
                                backgroundImage: (post.profileImage != null &&
                                        post.profileImage!.startsWith('http'))
                                    ? NetworkImage(post.profileImage!)
                                    : const AssetImage('assets/images/test.jpg')
                                        as ImageProvider,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: textColor,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        formatTime(
                                            DateTime.parse(post.timeAgo)),
                                        style: TextStyle(
                                            color: getTextColor(context),
                                            fontSize: 12),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.public,
                                          size: 14,
                                          color: getTextColor(context)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (post.postText.isNotEmpty)
                            Text(post.postText,
                                style:
                                    TextStyle(fontSize: 16, color: textColor)),
                          if (post.postImage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  post.postImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 200,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        color: getRedColor(context),
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  LoveIcon(
                                      post: post, onUpdate: _loadLikeCount),
                                  const SizedBox(width: 5),
                                  Text(likeCount.toString(),
                                      style: TextStyle(color: textColor)),
                                ],
                              ),
                              FavoriteIcon(
                                post: post,
                                onFavoriteChanged: (newStatus) {
                                  setState(() {
                                    post.isFavorited = newStatus;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Comments",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 8),
                  if (isLoadingComments)
                    Center(
                        child: CircularProgressIndicator(
                      color: getRedColor(context),
                    ))
                  else if (comments.isEmpty)
                    const Text("No comments yet.")
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final commenter = comments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: getRedColor(context).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commenter.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(commenter.commentText,
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                        hintText: "Write a comment...",
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                onPressed: _toggleEmojiPicker),
                            isSendingComment
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: getRedColor(context),
                                          strokeWidth: 2),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.send,
                                        color: getRedColor(context)),
                                    onPressed: _addComment),
                          ],
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: getRedColor(context),
                            width: 1.5,
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  setState(() {
                    _commentController.text += emoji.emoji;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
