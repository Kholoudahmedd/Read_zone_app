import 'package:get_storage/get_storage.dart';

class PostModel {
  final int id;
  final String username;
  final String timeAgo;
  final String postText;
  final String? postImage;
  final String? profileImage;

  int likeCount;
  bool isLoved;
  bool isFavorited;
  bool isMine; // ✅ جديدة: هل البوست بتاع المستخدم الحالي؟
  List<Commenter> commenters;
  int? commentCount;

  PostModel({
    required this.id,
    required this.username,
    required this.timeAgo,
    required this.postText,
    this.postImage,
    this.profileImage,
    this.likeCount = 0,
    this.isLoved = false,
    this.isFavorited = false,
    this.commentCount,
    List<Commenter>? commenters,
    this.isMine = false, // ✅ القيمة الافتراضية false
  }) : commenters = commenters ?? [];

  int get commentsCount => commenters.length;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final rawProfile = json['profileImageUrl'];
    final profileImage = (rawProfile != null && rawProfile != 'string')
        ? 'https://myfirstapi.runasp.net$rawProfile'
        : null;

    final rawPostImage = json['imageUrl'];
    final postImageUrl = (rawPostImage != null && rawPostImage != 'string')
        ? 'https://myfirstapi.runasp.net$rawPostImage'
        : null;

    final userId = GetStorage().read('userId');

    print(
        "POST ID: ${json['id']} | userId from API: ${json['userId']} | userId from Storage: $userId");

    return PostModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      username: json['username'] ?? '',
      timeAgo: json['createdAt'] ?? '',
      postText: json['content'] ?? '',
      postImage: postImageUrl,
      profileImage: profileImage,
      likeCount: json['likeCount'] ?? 0,
      isLoved: json['isLoved'] ?? false,
      isFavorited: json['isFavorited'] ?? false,
      commenters: (json['comments'] as List<dynamic>?)
              ?.map((e) => Commenter.fromJson(e))
              .toList() ??
          [],
      isMine: json['userId']?.toString() == userId?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'createdAt': timeAgo,
      'content': postText,
      'imageUrl': postImage,
      'profileImageUrl': profileImage,
      'likeCount': likeCount,
      'isLoved': isLoved,
      'isFavorited': isFavorited,
      'comments': commenters.map((e) => e.toJson()).toList(),
    };
  }
}

class Liker {
  final int userId;
  final String username;
  final String? profileImageUrl;

  Liker({
    required this.userId,
    required this.username,
    this.profileImageUrl,
  });

  factory Liker.fromJson(Map<String, dynamic> json) {
    final rawImage = json['profileImageUrl'];
    final image = (rawImage != null && rawImage != 'string')
        ? 'https://myfirstapi.runasp.net$rawImage'
        : null;

    return Liker(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      profileImageUrl: image,
    );
  }
}

class Commenter {
  final String username;
  final String? profileImage;
  final String commentText;

  Commenter({
    required this.username,
    this.profileImage,
    required this.commentText,
  });

  factory Commenter.fromJson(Map<String, dynamic> json) {
    final rawImage = json['profileImage'] ?? json['profileImageUrl'];
    final image = (rawImage != null && rawImage != 'string')
        ? 'https://myfirstapi.runasp.net$rawImage'
        : null;

    return Commenter(
      username: json['username'] ?? '',
      profileImage: image,
      commentText: json['commentText'] ?? json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profileImage': profileImage,
      'commentText': commentText,
    };
  }
}
