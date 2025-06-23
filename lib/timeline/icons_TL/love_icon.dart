import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
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
        color: widget.post.isLoved ? getRedColor(context) : Colors.grey,
      ),
      onPressed: _toggleLike,
    );
  }
}
