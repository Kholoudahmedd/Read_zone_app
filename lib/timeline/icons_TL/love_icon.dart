// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../pages_TL/love_page.dart';
// import '../model_TL/api_service.dart'; // لازم تستدعي الخدمة

// class LoveIcon extends StatefulWidget {
//   final PostModel post;
//   final VoidCallback onUpdate;

//   const LoveIcon({
//     Key? key,
//     required this.post,
//     required this.onUpdate,
//   }) : super(key: key);

//   @override
//   _LoveIconState createState() => _LoveIconState();
// }

// class _LoveIconState extends State<LoveIcon> {
//   int likeCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadLikeCount();
//   }

//   Future<void> _loadLikeCount() async {
//     final count = await ApiService.getPostLikeCount(widget.post.id);
//     setState(() {
//       likeCount = count;
//     });
//   }

//   Future<void> _toggleLike() async {
//     bool success;
//     if (widget.post.isLoved) {
//       success = await ApiService.unlikePost(widget.post.id);
//     } else {
//       success = await ApiService.likePost(widget.post.id);
//     }

//     if (success) {
//       setState(() {
//         widget.post.isLoved = !widget.post.isLoved;
//       });
//       await _loadLikeCount();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: Icon(
//             widget.post.isLoved ? Icons.favorite : Icons.favorite_border,
//             color: widget.post.isLoved ? Colors.red : Colors.grey,
//           ),
//           onPressed: _toggleLike,
//         ),
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => LovePage(post: widget.post),
//               ),
//             );
//           },
//           child: Text(
//             likeCount.toString(),
//             style: Theme.of(context).textTheme.bodyMedium,
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart'; // استدعاء الخدمة فقط (صفحة المعجبين مش لازمة هنا)

// class LoveIcon extends StatefulWidget {
//   final PostModel post;
//   final VoidCallback onUpdate;

//   const LoveIcon({
//     Key? key,
//     required this.post,
//     required this.onUpdate,
//   }) : super(key: key);

//   @override
//   _LoveIconState createState() => _LoveIconState();
// }

// class _LoveIconState extends State<LoveIcon> {
//   Future<void> _toggleLike() async {
//     bool success;
//     if (widget.post.isLoved) {
//       success = await ApiService.unlikePost(widget.post.id);
//     } else {
//       success = await ApiService.likePost(widget.post.id);
//     }

//     if (success) {
//       setState(() {
//         widget.post.isLoved = !widget.post.isLoved;
//       });
//       widget.onUpdate(); // لتحديث الرقم من الخارج (PostWidget)
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(
//         widget.post.isLoved ? Icons.favorite : Icons.favorite_border,
//         color: widget.post.isLoved ? Colors.red : Colors.grey,
//       ),
//       onPressed: _toggleLike,
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../model_TL/model_post.dart';
import '../model_TL/api_service.dart';

class LoveIcon extends StatefulWidget {
  final PostModel post;
  final VoidCallback onUpdate;

  const LoveIcon({
    Key? key,
    required this.post,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _LoveIconState createState() => _LoveIconState();
}

class _LoveIconState extends State<LoveIcon> {
  Future<void> _toggleLike() async {
    bool success;
    if (widget.post.isLoved) {
      success = await ApiService.unlikePost(widget.post.id);
    } else {
      success = await ApiService.likePost(widget.post.id);
    }

    if (success) {
      setState(() {
        widget.post.isLoved = !widget.post.isLoved;
      });

      widget.onUpdate(); // PostWidget هي اللي تحدث الرقم
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.post.isLoved ? Icons.favorite : Icons.favorite_border,
        color: widget.post.isLoved ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleLike,
    );
  }
}
