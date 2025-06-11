import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/screens/otp_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  bool isEmailValid = false;

  void validateEmail(String email) {
    setState(() {
      isEmailValid =
          email.isNotEmpty && RegExp(r'\S+@\S+\.\S+').hasMatch(email);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<bool> sendOtpViaApi(String email) async {
    try {
      final response = await Dio().post(
        'https://myfirstapi.runasp.net/api/Auth/forgot-password',
        data: {'email': email},
      );

      return response.statusCode == 200 && response.data == true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 10),
              child: Text(
                'Forgot\n your Password?',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, top: 10),
              child: Text(
                'Please enter the email address you’d like your password reset information sent to',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.4)
                      : const Color.fromARGB(255, 103, 104, 107),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: emailController,
                onChanged: validateEmail,
                decoration: InputDecoration(
                  label: Text(
                    'Email Address',
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 103, 104, 107),
                      fontSize: 14,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorText: isEmailValid || emailController.text.isEmpty
                      ? null
                      : 'Please enter a valid email address',
                ),
              ),
            ),
            const SizedBox(height: 80),
            Center(
              child: MaterialButton(
                hoverColor: const Color(0xffFF9A8C),
                minWidth: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                onPressed: isEmailValid
                    ? () async {
                        bool success =
                            await sendOtpViaApi(emailController.text.trim());
                        if (success) {
                          Get.snackbar(
                            "OTP Sent",
                            "An OTP has been sent to your email.",
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                          );
                          Get.to(() => OtpScreen(
                              userEmail: emailController.text.trim()));
                        } else {
                          Get.snackbar(
                            "Error",
                            "Failed to send OTP. Please check your email or try again later.",
                            snackPosition: SnackPosition.BOTTOM,
                            colorText: Colors.white,
                          );
                        }
                      }
                    : null,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xffC86B60)
                    : const Color(0xffFF9A8C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Submit',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xff3A6F73)
                      : const Color(0xffAED6DC),
                  'assets/images/vector 3.png',
                  height: 175,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
