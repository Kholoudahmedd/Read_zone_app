import 'package:flutter/material.dart';
import '../model_TL/model_post.dart';

class FavoriteIcon extends StatefulWidget {
  final PostModel post;

  const FavoriteIcon({Key? key, required this.post}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            widget.post.isFavorited ? Icons.star : Icons.star_border,
            color: widget.post.isFavorited ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              currentUser.toggleFavoritePost(widget.post);
            });
          },
        ),
        Text(
          'Favorite',
          style: TextStyle(
            fontSize: 16,
            color:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
