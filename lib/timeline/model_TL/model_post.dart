import 'dart:io';

class PostModel {
  final String id;
  final String profileImage;
  final String username;
  final String timeAgo;
  final String postText;
  final String? postImage;
  List<UserModel> lovedUsers;
  List<Commenter> commenters;
  bool isLoved;
  bool isFavorited;

  PostModel({
    required this.id,
    required this.profileImage,
    required this.username,
    required this.timeAgo,
    required this.postText,
    this.postImage,
    List<UserModel>? lovedUsers,
    List<Commenter>? commenters,
    this.isLoved = false,
    this.isFavorited = false,
  })  : lovedUsers = lovedUsers ?? [],
        commenters = commenters ?? [];

  int get loveCount => lovedUsers.length;
  int get commentsCount => commenters.length;

  void toggleLove() {
    if (isLoved) {
      lovedUsers.remove(currentUser);
    } else {
      lovedUsers.add(currentUser);
    }
    isLoved = !isLoved;
  }

  void addComment(String commentText, Commenter commenter) {
    commenters.add(commenter);
  }

  void toggleFavorite() {
    isFavorited = !isFavorited;
  }
}

class UserModel {
  String profileImage;
  String username;
  String email;
  List<PostModel> favorites;

  UserModel({
    required this.profileImage,
    required this.username,
    required this.email,
    List<PostModel>? favorites,
  }) : favorites = favorites ?? [];

  void toggleFavoritePost(PostModel post) {
    if (favorites.contains(post)) {
      favorites.remove(post);
      post.isFavorited = false;
    } else {
      favorites.add(post);
      post.isFavorited = true;
    }
  }

  void editProfile({
    String? newUsername,
    String? newEmail,
    String? newProfileImage,
  }) {
    if (newUsername != null) username = newUsername;
    if (newEmail != null) email = newEmail;
    if (newProfileImage != null) profileImage = newProfileImage;
  }
}

class Commenter {
  final String username;
  final String profileImage;
  final String commentText;

  Commenter({
    required this.username,
    required this.profileImage,
    required this.commentText,
  });
}

UserModel currentUser = UserModel(
  profileImage: "images_TL/profileimage.png",
  username: "Ross Ankunding",
  email: "rossankunding@gmail.com",
  favorites: [],
);

UserModel user1 = UserModel(
  profileImage: "images_TL/profile3.jpg",
  username: "Ahmed Ali",
  email: "ahmedali@example.com",
);

UserModel user2 = UserModel(
  profileImage: "images_TL/profile2.png",
  username: "Sara Ahmed",
  email: "saraahmed@example.com",
);

List<PostModel> dummyPosts = [
  PostModel(
    id: 'post_001',
    profileImage: "images_TL/profile3.jpg",
    username: "John Doe",
    timeAgo: "20min",
    postText:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    postImage: "images_TL/post1.png",
    lovedUsers: [user1, user2],
    commenters: [
      Commenter(
        username: "Ahmed Ali",
        profileImage: "images_TL/profile3.jpg",
        commentText: "Nice post!",
      ),
      Commenter(
        username: "Sara Ahmed",
        profileImage: "images_TL/profile2.png",
        commentText: "Great work!",
      ),
    ],
  ),
  PostModel(
    id: 'post_002',
    profileImage: "",
    username: "Mostfa",
    timeAgo: "5h",
    postText: "Lorem Ipsum has been the industry's standard dummy text.",
    postImage: "images_TL/post2.png",
    lovedUsers: [user1, user2],
    commenters: [
      Commenter(
        username: "John Doe",
        profileImage: "images_TL/profile3.jpg",
        commentText: "Looking good!",
      ),
      Commenter(
        username: "Sara Ahmed",
        profileImage: "images_TL/profile2.png",
        commentText: "Nice view!",
      ),
    ],
  ),
  PostModel(
    id: 'post_003', // id ثابت
    profileImage: "images_TL/profile2.png",
    username: "Sara Ahmed",
    timeAgo: "18h",
    postText: "It's been an amazing day, here's a glimpse!",
    postImage: "images_TL/post2.png",
    lovedUsers: [user2, user1],
    commenters: [
      Commenter(
        username: "John Doe",
        profileImage: "images_TL/profile2.png",
        commentText: "Wow, stunning!",
      ),
      Commenter(
        username: "Ahmed Ali",
        profileImage: "images_TL/profile3.jpg",
        commentText: "So beautiful!",
      ),
    ],
  ),
];

void addNewPost(String postText, File? image) {
  final newPost = PostModel(
    id: 'post_${dummyPosts.length + 1}', // تعيين id جديد للبوست
    profileImage: currentUser.profileImage,
    username: currentUser.username,
    timeAgo: "just now",
    postText: postText,
    postImage: image != null ? image.path : null,
    lovedUsers: [],
    commenters: [],
  );
  dummyPosts.insert(0, newPost);
}
