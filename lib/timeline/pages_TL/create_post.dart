// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:read_zone_app/themes/colors.dart';
// import '../model_TL/api_service.dart';

// class CreatePostPage extends StatefulWidget {
//   final File? selectedImage;

//   CreatePostPage({this.selectedImage});

//   @override
//   _CreatePostPageState createState() => _CreatePostPageState();
// }

// class _CreatePostPageState extends State<CreatePostPage> {
//   final TextEditingController _postController = TextEditingController();
//   File? _selectedImage;

//   Map<String, String> userData = {
//     'userName': 'Guest User',
//     'userImage': 'assets/images/test.jpg',
//   };

//   @override
//   void initState() {
//     super.initState();
//     if (widget.selectedImage != null) {
//       _selectedImage = widget.selectedImage;
//     }
//   }

//   bool get canPost => _postController.text.isNotEmpty || _selectedImage != null;

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void createPost() async {
//     String postText = _postController.text;

//     if (canPost) {
//       bool success = await ApiService.createPost(
//           content: postText, imageFile: _selectedImage);
//       if (success) {
//         // لو الرفع ناجح رجع للصفحة السابقة
//         Navigator.pop(context, true);
//       } else {
//         // لو في خطأ ممكن تظهر رسالة خطأ
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('فشل رفع المنشور. حاول مرة أخرى')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Create Post"),
//         scrolledUnderElevation: 0,
//         backgroundColor: Colors.transparent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // صورة واسم المستخدم
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: userData['userImage']!.startsWith('http')
//                       ? NetworkImage(userData['userImage']!)
//                       : AssetImage(userData['userImage']!) as ImageProvider,
//                   radius: 25,
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   userData['userName']!,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),

//             // حقل النص
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Theme.of(context).primaryColor,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextField(
//                 controller: _postController,
//                 maxLines: null,
//                 keyboardType: TextInputType.multiline,
//                 decoration: InputDecoration(
//                   hintText: "What's on your mind?",
//                   hintStyle: TextStyle(color: getTextColor(context)),
//                   border: InputBorder.none,
//                   filled: true,
//                   fillColor: Theme.of(context).scaffoldBackgroundColor,
//                 ),
//                 onChanged: (text) => setState(() {}),
//               ),
//             ),
//             SizedBox(height: 10),

//             // عرض الصورة المختارة
//             if (_selectedImage != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Image.file(
//                         _selectedImage!,
//                         width: double.infinity,
//                         height: 200,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       right: 5,
//                       top: 5,
//                       child: CircleAvatar(
//                         backgroundColor: Colors.black54,
//                         child: IconButton(
//                           icon: Icon(Icons.close, color: Colors.white),
//                           onPressed: () {
//                             setState(() {
//                               _selectedImage = null;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//             // أزرار
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: Icon(
//                     Icons.photo_album,
//                     color: getTextColor(context),
//                     size: 30,
//                   ),
//                   onPressed: _pickImage,
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: canPost ? createPost : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: getRedColor(context),
//                   ),
//                   child: Text(
//                     "Post",
//                     style: TextStyle(color: getTextColor2(context)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// create_post.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/api_service.dart';
import '../../services/auth_service.dart';

class CreatePostPage extends StatefulWidget {
  final File? selectedImage;

  CreatePostPage({this.selectedImage});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedImage;
  String? username;
  String? email;
  String? userImage;
  bool isLoading = false;
  final String baseUrl = 'https://myfirstapi.runasp.net/';

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      _selectedImage = widget.selectedImage;
    }
    loadUserProfile();
  }

  void loadUserProfile() async {
    final authService = AuthService();
    final profile = await authService.getProfile();

    if (!mounted) return;

    if (profile != null) {
      final profileImage = profile['profileImageUrl'];
      setState(() {
        username = profile['username'];
        email = profile['email'];
        userImage = profileImage != null && profileImage != ''
            ? '$baseUrl$profileImage'
            : null;
      });
    } else {
      print("ERROR: Failed to load user profile");
    }
  }

  bool get canPost => _postController.text.isNotEmpty || _selectedImage != null;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void createPost() async {
    setState(() {
      isLoading = true;
    });

    String postText = _postController.text;

    if (canPost) {
      bool success = await ApiService.createPost(
        content: postText,
        imageFile: _selectedImage,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post failed. Please try again.')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Create Post"),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      (userImage != null && userImage!.startsWith('http'))
                          ? NetworkImage(userImage!)
                          : const AssetImage('assets/images/test.jpg')
                              as ImageProvider,
                  radius: 25,
                ),
                SizedBox(width: 10),
                Text(
                  username ?? 'Loading...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _postController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: getTextColor(context)),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.photo_album,
                      color: getTextColor(context), size: 30),
                  onPressed: isLoading ? null : _pickImage,
                ),
                SizedBox(width: 10),
                isLoading
                    ? CircularProgressIndicator(color: getRedColor(context))
                    : ElevatedButton(
                        onPressed: canPost ? createPost : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getRedColor(context),
                        ),
                        child: Text("Post",
                            style: TextStyle(color: getTextColor2(context))),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
