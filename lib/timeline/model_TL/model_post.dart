// class PostModel {
//   final int id;
//   final String profileImage;
//   final String username;
//   final String timeAgo;
//   final String postText;
//   final String? postImage;

//   int likeCount;
//   bool isLoved;

//   List<Commenter> commenters;
//   bool isFavorited;

//   PostModel({
//     required this.id,
//     required this.profileImage,
//     required this.username,
//     required this.timeAgo,
//     required this.postText,
//     this.postImage,
//     this.likeCount = 0,
//     this.isLoved = false,
//     List<Commenter>? commenters,
//     this.isFavorited = false,
//   }) : commenters = commenters ?? [];

//   int get commentsCount => commenters.length;

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id'].toString()) ?? 0,
//       profileImage: json['profileImageUrl'] ?? '',
//       username: json['username'] ?? '',
//       timeAgo: json['createdAt'] ?? '',
//       postText: json['content'] ?? '',
//       postImage: json['postImage'],
//       likeCount: json['likeCount'] ?? 0,
//       isLoved: json['isLoved'] ?? false,
//       isFavorited: json['isFavorited'] ?? false,
//       commenters: (json['comments'] as List<dynamic>?)
//               ?.map((commentJson) => Commenter.fromJson(commentJson))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'profileImageUrl': profileImage,
//       'username': username,
//       'createdAt': timeAgo,
//       'content': postText,
//       'postImage': postImage,
//       'isFavorited': isFavorited,
//     };
//   }
// }

// class Liker {
//   final int userId;
//   final String username;
//   final String profileImageUrl;

//   Liker({
//     required this.userId,
//     required this.username,
//     required this.profileImageUrl,
//   });

//   factory Liker.fromJson(Map<String, dynamic> json) {
//     return Liker(
//       userId: json['userId'],
//       username: json['username'],
//       profileImageUrl: json['profileImageUrl'],
//     );
//   }
// }

// class Commenter {
//   final String username;
//   final String profileImage;
//   final String commentText;

//   Commenter({
//     required this.username,
//     required this.profileImage,
//     required this.commentText,
//   });

//   // factory Commenter.fromJson(Map<String, dynamic> json) {
//   //   return Commenter(
//   //     username: json['username'] ?? '',
//   //     profileImage: json['profileImage'] ?? '',
//   //     commentText: json['commentText'] ?? '',
//   //   );
//   // // }
//   // factory Commenter.fromJson(Map<String, dynamic> json) {
//   //   return Commenter(
//   //     username: json['username'] ?? '',
//   //     profileImage: json['profileImage'] ?? json['profileImageUrl'] ?? '',
//   //     commentText: json['commentText'] ?? json['text'] ?? '',
//   //   );
//   // }
//   // factory Commenter.fromJson(Map<String, dynamic> json) {
//   //   return Commenter(
//   //     username: json['username'] ?? '',
//   //     profileImage: json['profileImage'] ?? json['profileImageUrl'] ?? '',
//   //     commentText: json['text'] ?? '',
//   //   );
//   // }
//   factory Commenter.fromJson(Map<String, dynamic> json) {
//     return Commenter(
//       username: json['username'] ?? '',
//       profileImage: json['profileImage'] ?? json['profileImageUrl'] ?? '',
//       commentText: json['commentText'] ?? json['text'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'profileImage': profileImage,
//       'commentText': commentText,
//     };
//   }
// }
// class PostModel {
//   final int id;
//   final String? profileImage; // ممكن تكون null
//   final String username;
//   final String timeAgo;
//   final String postText;
//   final String? postImage;

//   int likeCount;
//   bool isLoved;
//   bool isFavorited;
//   List<Commenter> commenters;

//   PostModel({
//     required this.id,
//     required this.profileImage,
//     required this.username,
//     required this.timeAgo,
//     required this.postText,
//     this.postImage,
//     this.likeCount = 0,
//     this.isLoved = false,
//     this.isFavorited = false,
//     List<Commenter>? commenters,
//   }) : commenters = commenters ?? [];

//   int get commentsCount => commenters.length;

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string' && rawImage != '')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return PostModel(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id'].toString()) ?? 0,
//       profileImage: image,
//       username: json['username'] ?? '',
//       timeAgo: json['createdAt'] ?? '',
//       postText: json['content'] ?? '',
//       postImage: json['postImage'],
//       likeCount: json['likeCount'] ?? 0,
//       isLoved: json['isLoved'] ?? false,
//       isFavorited: json['isFavorited'] ?? false,
//       commenters: (json['comments'] as List<dynamic>?)
//               ?.map((c) => Commenter.fromJson(c))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'profileImageUrl': profileImage,
//       'username': username,
//       'createdAt': timeAgo,
//       'content': postText,
//       'postImage': postImage,
//       'isFavorited': isFavorited,
//     };
//   }
// }

// class Liker {
//   final int userId;
//   final String username;
//   final String? profileImageUrl;

//   Liker({
//     required this.userId,
//     required this.username,
//     this.profileImageUrl,
//   });

//   factory Liker.fromJson(Map<String, dynamic> json) {
//     final raw = json['profileImageUrl'];
//     final img = (raw != null && raw != 'string' && raw != '')
//         ? 'https://myfirstapi.runasp.net$raw'
//         : null;

//     return Liker(
//       userId: json['userId'],
//       username: json['username'],
//       profileImageUrl: img,
//     );
//   }
// }

// class Commenter {
//   final String username;
//   final String? profileImage;
//   final String commentText;

//   Commenter({
//     required this.username,
//     required this.profileImage,
//     required this.commentText,
//   });

//   factory Commenter.fromJson(Map<String, dynamic> json) {
//     final raw = json['profileImage'] ?? json['profileImageUrl'];
//     final img = (raw != null && raw != 'string' && raw != '')
//         ? 'https://myfirstapi.runasp.net$raw'
//         : null;

//     return Commenter(
//       username: json['username'] ?? '',
//       profileImage: img,
//       commentText: json['commentText'] ?? json['text'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'profileImage': profileImage,
//       'commentText': commentText,
//     };
//   }
// }

// class PostModel {
//   final int id;
//   final String username;
//   final String timeAgo;
//   final String postText;
//   final String? postImage;

//   final String? profileImage; // ممكن تكون null
//   int likeCount;
//   bool isLoved;
//   bool isFavorited;

//   List<Commenter> commenters;

//   PostModel({
//     required this.id,
//     required this.username,
//     required this.timeAgo,
//     required this.postText,
//     this.postImage,
//     this.profileImage,
//     this.likeCount = 0,
//     this.isLoved = false,
//     this.isFavorited = false,
//     List<Commenter>? commenters,
//   }) : commenters = commenters ?? [];

//   int get commentsCount => commenters.length;

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return PostModel(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id'].toString()) ?? 0,
//       username: json['username'] ?? '',
//       timeAgo: json['createdAt'] ?? '',
//       postText: json['content'] ?? '',
//       postImage: json['imageUrl'], // أو 'postImage' حسب اسم الـ API
//       profileImage: image,
//       likeCount: json['likeCount'] ?? 0,
//       isLoved: json['isLoved'] ?? false,
//       isFavorited: json['isFavorited'] ?? false,
//       commenters: (json['comments'] as List<dynamic>?)
//               ?.map((e) => Commenter.fromJson(e))
//               .toList() ??
//           [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'createdAt': timeAgo,
//       'content': postText,
//       'imageUrl': postImage,
//       'profileImageUrl': profileImage,
//       'likeCount': likeCount,
//       'isLoved': isLoved,
//       'isFavorited': isFavorited,
//       'comments': commenters.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class Liker {
//   final int userId;
//   final String username;
//   final String? profileImageUrl;

//   Liker({
//     required this.userId,
//     required this.username,
//     this.profileImageUrl,
//   });

//   factory Liker.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return Liker(
//       userId: json['userId'] ?? 0,
//       username: json['username'] ?? '',
//       profileImageUrl: image,
//     );
//   }
// }

// class Commenter {
//   final String username;
//   final String? profileImage;
//   final String commentText;

//   Commenter({
//     required this.username,
//     this.profileImage,
//     required this.commentText,
//   });

//   factory Commenter.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImage'] ?? json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return Commenter(
//       username: json['username'] ?? '',
//       profileImage: image,
//       commentText: json['commentText'] ?? json['text'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'profileImage': profileImage,
//       'commentText': commentText,
//     };
//   }
// }
//شغال ماعدا حذف

// class PostModel {
//   final int id;
//   final String username;
//   final String timeAgo;
//   final String postText;
//   final String? postImage;
//   final String? profileImage;

//   int likeCount;
//   bool isLoved;
//   bool isFavorited;
//   List<Commenter> commenters;

//   int? commentCount; // ✅ عدد التعليقات من API خارجي

//   PostModel({
//     required this.id,
//     required this.username,
//     required this.timeAgo,
//     required this.postText,
//     this.postImage,
//     this.profileImage,
//     this.likeCount = 0,
//     this.isLoved = false,
//     this.isFavorited = false,
//     this.commentCount, // ✅ هنا ضفناها
//     List<Commenter>? commenters,
//   }) : commenters = commenters ?? [];

//   int get commentsCount => commenters.length;

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return PostModel(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id'].toString()) ?? 0,
//       username: json['username'] ?? '',
//       timeAgo: json['createdAt'] ?? '',
//       postText: json['content'] ?? '',
//       postImage: json['imageUrl'],
//       profileImage: image,
//       likeCount: json['likeCount'] ?? 0,
//       isLoved: json['isLoved'] ?? false,
//       isFavorited: json['isFavorited'] ?? false,
//       commenters: (json['comments'] as List<dynamic>?)
//               ?.map((e) => Commenter.fromJson(e))
//               .toList() ??
//           [],
//       // مفيش commentCount هنا لأنها بتيجي من API منفصل
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'username': username,
//       'createdAt': timeAgo,
//       'content': postText,
//       'imageUrl': postImage,
//       'profileImageUrl': profileImage,
//       'likeCount': likeCount,
//       'isLoved': isLoved,
//       'isFavorited': isFavorited,
//       'comments': commenters.map((e) => e.toJson()).toList(),
//       // مش هنضيف commentCount هنا كمان
//     };
//   }
// }

// class Liker {
//   final int userId;
//   final String username;
//   final String? profileImageUrl;

//   Liker({
//     required this.userId,
//     required this.username,
//     this.profileImageUrl,
//   });

//   factory Liker.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return Liker(
//       userId: json['userId'] ?? 0,
//       username: json['username'] ?? '',
//       profileImageUrl: image,
//     );
//   }
// }

// class Commenter {
//   final String username;
//   final String? profileImage;
//   final String commentText;

//   Commenter({
//     required this.username,
//     this.profileImage,
//     required this.commentText,
//   });

//   factory Commenter.fromJson(Map<String, dynamic> json) {
//     final rawImage = json['profileImage'] ?? json['profileImageUrl'];
//     final image = (rawImage != null && rawImage != 'string')
//         ? 'https://myfirstapi.runasp.net$rawImage'
//         : null;

//     return Commenter(
//       username: json['username'] ?? '',
//       profileImage: image,
//       commentText: json['commentText'] ?? json['text'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'username': username,
//       'profileImage': profileImage,
//       'commentText': commentText,
//     };
//   }
// }

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

  // factory PostModel.fromJson(Map<String, dynamic> json) {
  //   final rawImage = json['profileImageUrl'];
  //   final image = (rawImage != null && rawImage != 'string')
  //       ? 'https://myfirstapi.runasp.net$rawImage'
  //       : null;

  //   final userId = GetStorage().read('userId'); // 🧠 المستخدم الحالي
  //   print(
  //       "POST ID: ${json['id']} | userId from API: ${json['userId']} | userId from Storage: ${userId}");

  //   return PostModel(
  //     id: json['id'] is int
  //         ? json['id']
  //         : int.tryParse(json['id'].toString()) ?? 0,
  //     username: json['username'] ?? '',
  //     timeAgo: json['createdAt'] ?? '',
  //     postText: json['content'] ?? '',
  //     postImage: json['imageUrl'],
  //     profileImage: image,
  //     likeCount: json['likeCount'] ?? 0,
  //     isLoved: json['isLoved'] ?? false,
  //     isFavorited: json['isFavorited'] ?? false,
  //     commenters: (json['comments'] as List<dynamic>?)
  //             ?.map((e) => Commenter.fromJson(e))
  //             .toList() ??
  //         [],

  //     isMine: json['userId']?.toString() == userId?.toString(),
  //     // ✅ المقارنة
  //   );
  // }
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
