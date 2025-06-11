import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/login_Screen.dart';

class SignedUpScreen extends StatelessWidget {
  const SignedUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Congratulations !',
                style: GoogleFonts.poppins(
                    fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                'Your Account has been Regestired',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(
                  () => const Loginscreen(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 300),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffFF9A8C), Color(0xffAED6DB)],
                      begin: Alignment.topRight,
                      end: Alignment.topLeft),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                height: 60,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Center(
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/vector 3.png',
              height: 150,
            )),
        Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/vector 3 - Copy.png',
              height: 150,
            ))
      ]),
    );
  }
}
