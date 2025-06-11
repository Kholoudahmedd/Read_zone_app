import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FeaturedBooks extends StatelessWidget {
  FeaturedBooks({required this.item, Key? key}) : super(key: key);
  var item;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 20, // You need to specify how many items to display
      itemBuilder: (context, index) {
        return item;
      },
    );
  }
}
