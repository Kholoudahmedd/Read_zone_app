import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFields extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final bool obtext;
  final Function(String)? onchanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller; // Added controller

  TextFields({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.obtext,
    this.onchanged,
    this.validator,
    this.controller, // Initialize controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 385,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(2),
      ),
      child: TextFormField(
        controller: controller, // Use controller if provided
        validator: (data) {
          if (data == null || data.isEmpty) {
            return 'This Field is Required';
          }
          return validator?.call(data); // Use provided validator if available
        },
        onChanged: onchanged,
        obscureText: obtext,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.4)
                : Color(0XFFA4A9B5),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(
              color: Color(0XFFA4A9B5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(
              color: Color(0XFFA4A9B5),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: icon,
          ),
        ),
      ),
    );
  }
}
