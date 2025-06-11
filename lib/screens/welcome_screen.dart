import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/screens/SignUpscreen.dart';
import 'package:read_zone_app/screens/login_Screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Welcome to Read Zone!',
                style: GoogleFonts.gabarito(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' Your gateway to stories, knowledge, and inspiration.',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 127, 127, 127)),
              ),
              Text(
                ' Let the journey begin!',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 127, 127, 127)),
              ),
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/welcome.png',
                height: 300,
              ),
              SizedBox(
                height: 150,
              ),
              MaterialButton(
                hoverColor: Color(0xffFF9A8C),
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                onPressed: () {
                  Get.to(
                    () => const Loginscreen(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                // color: Color(0XFFAED6DB),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xff3A6F73)
                          : Color(0xffAED6DC),
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Login',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              MaterialButton(
                hoverColor: Color(0xffAED6DB),
                minWidth: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                onPressed: () {
                  Get.to(
                    () => Signupscreen(),
                    transition: Transition.fade,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xff3A6F73)
                    : Color(0xffAED6DC),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
                    ),
                  ),
          )),
    );
  }
}
