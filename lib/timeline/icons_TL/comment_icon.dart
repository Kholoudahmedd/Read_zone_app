import 'package:flutter/material.dart';

class CommentIcon extends StatelessWidget {
  final VoidCallback onPressed;

  const CommentIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.comment, color: Colors.grey),
      onPressed: onPressed,
    );
  }
}
