// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart';

// class FavoriteIcon extends StatefulWidget {
//   final PostModel post;

//   const FavoriteIcon({Key? key, required this.post}) : super(key: key);

//   @override
//   _FavoriteIconState createState() => _FavoriteIconState();
// }

// class _FavoriteIconState extends State<FavoriteIcon> {
//   bool isLoading = false;

//   void _toggleFavorite() async {
//     setState(() {
//       isLoading = true;
//     });

//     bool success;
//     if (!widget.post.isFavorited) {
//       success = await ApiService.addToFavorites(widget.post.id);
//     } else {
//       success = await ApiService.removeFromFavorites(widget.post.id);
//     }

//     if (success) {
//       setState(() {
//         widget.post.isFavorited = !widget.post.isFavorited;
//       });
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: isLoading
//               ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Icon(
//                   widget.post.isFavorited ? Icons.star : Icons.star_border,
//                   color: widget.post.isFavorited ? Colors.amber : Colors.grey,
//                 ),
//           onPressed: isLoading ? null : _toggleFavorite,
//         ),
//         Text(
//           'Favorite',
//           style: TextStyle(
//             fontSize: 16,
//             color:
//                 Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }
//شغال بيعرض
// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart';

// class FavoriteIcon extends StatefulWidget {
//   final PostModel post;
//   final VoidCallback? onFavoriteChanged;

//   const FavoriteIcon({Key? key, required this.post, this.onFavoriteChanged})
//       : super(key: key);

//   @override
//   _FavoriteIconState createState() => _FavoriteIconState();
// }

// class _FavoriteIconState extends State<FavoriteIcon> {
//   bool isLoading = false;

//   void _toggleFavorite() async {
//     setState(() {
//       isLoading = true;
//     });

//     bool success;
//     if (!widget.post.isFavorited) {
//       success = await ApiService.addToFavorites(widget.post.id);
//     } else {
//       success = await ApiService.removeFromFavorites(widget.post.id);
//     }

//     if (success) {
//       setState(() {
//         widget.post.isFavorited = !widget.post.isFavorited;
//       });
//       // نخبر الأب أن حالة المفضلة تغيرت
//       widget.onFavoriteChanged?.call();
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: isLoading
//           ? SizedBox(
//               width: 20,
//               height: 20,
//               child: CircularProgressIndicator(strokeWidth: 2),
//             )
//           : Icon(
//               widget.post.isFavorited ? Icons.star : Icons.star_border,
//               color: widget.post.isFavorited ? Colors.amber : Colors.grey,
//             ),
//       onPressed: isLoading ? null : _toggleFavorite,
//     );
//   }
// }

// class FavoriteIcon extends StatefulWidget {
//   final PostModel post;

//   const FavoriteIcon({Key? key, required this.post}) : super(key: key);

//   @override
//   _FavoriteIconState createState() => _FavoriteIconState();
// }

// class _FavoriteIconState extends State<FavoriteIcon> {
//   bool isLoading = false;

//   // الدالة دي مسؤولة عن تبديل حالة الفيفورت
//   void _toggleFavorite() async {
//     setState(() {
//       isLoading = true; // تفعيل تحميل (progress) عشان نعرف العملية شغالة
//       print('Start toggle favorite for post id: ${widget.post.id}');
//     });

//     bool success;
//     // لو مش مفضل حاليا هنضيفه للمفضلات
//     if (!widget.post.isFavorited) {
//       print('Calling API to add to favorites...');
//       success = await ApiService.addToFavorites(widget.post.id);
//       print('Add to favorites API returned: $success');
//     } else {
//       // لو مفضل بالفعل هنشيله من المفضلات
//       print('Calling API to remove from favorites...');
//       success = await ApiService.removeFromFavorites(widget.post.id);
//       print('Remove from favorites API returned: $success');
//     }

//     if (success) {
//       // لو العملية نجحت، نغير حالة المفضلات محليا
//       setState(() {
//         widget.post.isFavorited = !widget.post.isFavorited;
//         print('Favorite state updated locally: ${widget.post.isFavorited}');
//       });
//     } else {
//       print('API call failed, favorite state not changed');
//     }

//     setState(() {
//       isLoading = false; // وقف تحميل progress
//       print('Toggle favorite finished');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         IconButton(
//           icon: isLoading
//               ? SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Icon(
//                   widget.post.isFavorited ? Icons.star : Icons.star_border,
//                   color: widget.post.isFavorited ? Colors.amber : Colors.grey,
//                 ),
//           onPressed: isLoading ? null : _toggleFavorite,
//         ),
//         Text(
//           'Favorite',
//           style: TextStyle(
//             fontSize: 16,
//             color:
//                 Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart';

// class FavoriteIcon extends StatefulWidget {
//   final PostModel post;
//   final VoidCallback? onFavoriteChanged;

//   const FavoriteIcon({
//     Key? key,
//     required this.post,
//     this.onFavoriteChanged,
//   }) : super(key: key);

//   @override
//   _FavoriteIconState createState() => _FavoriteIconState();
// }

// class _FavoriteIconState extends State<FavoriteIcon> {
//   bool isLoading = false;

//   void _toggleFavorite() async {
//     setState(() {
//       isLoading = true;
//     });

//     bool success;
//     if (!widget.post.isFavorited) {
//       success = await ApiService.addToFavorites(widget.post.id);
//     } else {
//       success = await ApiService.removeFromFavorites(widget.post.id);
//     }

//     if (success) {
//       setState(() {
//         widget.post.isFavorited = !widget.post.isFavorited;
//       });
//       widget.onFavoriteChanged?.call();
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isFav = widget.post.isFavorited;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: isLoading
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Icon(
//                   isFav ? Icons.star : Icons.star_border,
//                   color: isFav ? Colors.amber : Colors.grey,
//                 ),
//           onPressed: isLoading ? null : _toggleFavorite,
//         ),
//         AnimatedDefaultTextStyle(
//           duration: Duration(milliseconds: 300),
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: isFav ? Colors.amber : Colors.grey,
//           ),
//           child: const Text('Favorite'),
//         ),
//       ],
//     );
//   }
// // }
// import 'package:flutter/material.dart';
// import '../model_TL/model_post.dart';
// import '../model_TL/api_service.dart';

// class FavoriteIcon extends StatefulWidget {
//   final PostModel post;
//   final ValueChanged<bool>? onFavoriteChanged; // ترجع الحالة الجديدة

//   const FavoriteIcon({
//     Key? key,
//     required this.post,
//     this.onFavoriteChanged,
//   }) : super(key: key);

//   @override
//   _FavoriteIconState createState() => _FavoriteIconState();
// }

// class _FavoriteIconState extends State<FavoriteIcon> {
//   bool isLoading = false;

//   Future<void> _handleToggleFavorite() async {
//     setState(() {
//       isLoading = true;
//     });

//     bool success = false;
//     final postId = widget.post.id;

//     if (!widget.post.isFavorited) {
//       success = await ApiService.addToFavorites(postId);
//     } else {
//       success = await ApiService.removeFromFavorites(postId);
//     }

//     if (success && mounted) {
//       // بنبلغ الأب بالحالة الجديدة
//       widget.onFavoriteChanged?.call(!widget.post.isFavorited);
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isFav = widget.post.isFavorited;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: isLoading
//               ? const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(strokeWidth: 2),
//                 )
//               : Icon(
//                   isFav ? Icons.star : Icons.star_border,
//                   color: isFav ? Colors.amber : Colors.grey,
//                 ),
//           onPressed: isLoading ? null : _handleToggleFavorite,
//         ),
//         const Text(
//           'Favorite',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w500,
//             color: Colors.black, // ثابت زي ما طلبتي
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../model_TL/api_service.dart';

class FavoriteIcon extends StatefulWidget {
  final PostModel post;
  final ValueChanged<bool>? onFavoriteChanged; // ترجع الحالة الجديدة

  const FavoriteIcon({
    Key? key,
    required this.post,
    this.onFavoriteChanged,
  }) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  bool isLoading = false;

  Future<void> _handleToggleFavorite() async {
    setState(() {
      isLoading = true;
    });

    bool success = false;
    final postId = widget.post.id;

    if (!widget.post.isFavorited) {
      success = await ApiService.addToFavorites(postId);
    } else {
      success = await ApiService.removeFromFavorites(postId);
    }

    // if (success && mounted) {
    //   // بنبلغ الأب بالحالة الجديدة
    //   widget.onFavoriteChanged?.call(!widget.post.isFavorited);
    // }
    if (success && mounted) {
      setState(() {
        widget.post.isFavorited =
            !widget.post.isFavorited; // ✅ غيرنا الحالة داخليًا
        isLoading = false;
      });

      widget.onFavoriteChanged?.call(widget.post.isFavorited);
    } else {
      setState(() => isLoading = false);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFav = widget.post.isFavorited;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: getRedColor(context),
                  ),
                )
              : Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.amber : Colors.grey,
                ),
          onPressed: isLoading ? null : _handleToggleFavorite,
        ),
        const Text(
          'Favorite',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
