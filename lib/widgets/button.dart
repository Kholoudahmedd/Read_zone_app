import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Button({required this.Buttontext});

  String Buttontext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70),
        color: Color(0xffFF9A8C),
      ),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Center(
        child: Text(
          Buttontext,
          style: GoogleFonts.inter(
            letterSpacing: 1,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
