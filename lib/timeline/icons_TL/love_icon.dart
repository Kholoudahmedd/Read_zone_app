import 'package:flutter/material.dart';
import '../model_TL/model_post.dart';
import '../pages_TL/love_page.dart';

class LoveIcon extends StatefulWidget {
  final PostModel post;

  const LoveIcon({Key? key, required this.post}) : super(key: key);

  @override
  _LoveIconState createState() => _LoveIconState();
}

class _LoveIconState extends State<LoveIcon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            widget.post.isLoved ? Icons.favorite : Icons.favorite_border,
            color: widget.post.isLoved ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              widget.post.toggleLove();
            });
          },
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LovePage(post: widget.post),
              ),
            );
          },
          child: Text(
            widget.post.loveCount.toString(), // عرض عدد الإعجابات
            style: Theme.of(context).textTheme.bodyMedium, // استدعاء headline1
          ),
        ),
      ],
    );
  }
}
