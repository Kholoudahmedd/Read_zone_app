import 'package:flutter/material.dart';

class BookDetailsItem extends StatelessWidget {
  const BookDetailsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              Container(
                color: const Color(0xff4A536B),
                height: MediaQuery.of(context).size.height * 0.4,
              ),
            ],
          ),
          Positioned(
            right: 20,
            left: 20,
            top: 3,
            child: Image.asset(
              'assets/images/THEPUSH.png',
              height: MediaQuery.of(context).size.height * 0.46,
            ),
          ),
        ],
      ),
    );
  }
}
