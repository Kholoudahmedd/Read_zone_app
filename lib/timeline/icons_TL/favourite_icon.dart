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
                  color: isFav ? getRedColor(context) : Colors.grey,
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
