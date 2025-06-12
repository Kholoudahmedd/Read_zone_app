import 'dart:async';
import 'dart:convert';
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
  bool isLoading = false;
  bool canResendOtp = true;
  int resendTimeout = 60;
  Timer? resendTimer;
  final Dio _dio = Dio();

  void validateEmail(String email) {
    setState(() {
      isEmailValid =
          email.isNotEmpty && RegExp(r'\S+@\S+\.\S+').hasMatch(email);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    resendTimer?.cancel();
    _dio.close();
    super.dispose();
  }

  void startResendTimer() {
    setState(() {
      canResendOtp = false;
      resendTimeout = 60;
    });

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimeout > 0) {
        setState(() {
          resendTimeout--;
        });
      } else {
        timer.cancel();
        setState(() {
          canResendOtp = true;
        });
      }
    });
  }

  Future<bool> sendOtpViaApi(String email) async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.post(
        'https://myfirstapi.runasp.net/api/Auth/forgot-password',
        data: {'Email': email},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        // Handle different response formats
        final responseData = response.data;

        if (responseData is Map) {
          // If response is JSON object
          if (responseData.containsKey('message')) {
            Get.snackbar(
              "Success",
              responseData['message'].toString(),
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
            );
          }
        } else if (responseData is String) {
          // If response is plain text
          Get.snackbar(
            "Success",
            responseData,
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
          );
        }

        startResendTimer();
        return true;
      } else {
        throw Exception(
            'Server responded with status code ${response.statusCode}');
      }
    } on DioError catch (e) {
      String errorMessage = "Failed to connect to server";

      if (e.response != null) {
        // Handle different error response formats
        if (e.response!.data is Map) {
          errorMessage = e.response!.data['message']?.toString() ??
              e.response!.data.toString();
        } else {
          errorMessage = e.response!.data?.toString() ?? errorMessage;
        }
      } else {
        errorMessage = e.message ?? errorMessage;
      }

      Get.snackbar(
        "Error",
        "An unexpected error occurred , please try again later",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      // Get.snackbar(
      //   "Error",
      //   "An unexpected error occurred",
      //   snackPosition: SnackPosition.BOTTOM,
      //   colorText: Colors.white,
      // );
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
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
                'Please enter the email address you\'d like your password reset information sent to',
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
            const SizedBox(height: 20),
            Center(
              child: Text(
                canResendOtp
                    ? ''
                    : 'You can request a new OTP in $resendTimeout seconds',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: MaterialButton(
                hoverColor: const Color(0xffFF9A8C),
                minWidth: MediaQuery.of(context).size.width * 0.9,
                height: 60,
                onPressed: isEmailValid && !isLoading && canResendOtp
                    ? () async {
                        bool success =
                            await sendOtpViaApi(emailController.text.trim());
                        if (success) {
                          Get.to(() =>
                              OtpScreen(email: emailController.text.trim()));
                        }
                      }
                    : null,
                color: isEmailValid && !isLoading && canResendOtp
                    ? Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xffC86B60)
                        : const Color(0xffFF9A8C)
                    : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        canResendOtp ? 'Submit' : 'Please wait',
                        style: GoogleFonts.inter(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
