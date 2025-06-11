import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:read_zone_app/screens/reset_password.dart';

class OtpScreen extends StatefulWidget {
  final String userEmail;

  const OtpScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController controller = TextEditingController();
  bool isOtpValid = false;
  final Dio dio = Dio();

  void validateOtp(String otp) {
    setState(() {
      isOtpValid = otp.length == 4;
    });
  }

  Future<void> verifyOtp(String otp) async {
    try {
      final response = await dio.post(
        'https://myfirstapi.runasp.net/api/Auth/verify-otp',
        data: {
          "email": widget.userEmail,
          "otp": otp,
        },
      );

      if (response.statusCode == 200 && response.data == true) {
        Get.to(() => ResetPassword(
              email: '',
            ));
      } else {
        Get.snackbar(
          "Error",
          "Invalid OTP. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Server error occurred. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 64,
      textStyle: GoogleFonts.inter(fontSize: 20, color: Colors.black),
      decoration: const BoxDecoration(
        color: Color(0XFFA4A9B5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text(
                  'Enter OTP',
                  style: GoogleFonts.inter(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 20, top: 30),
                child: Text(
                  'Enter 4 digit verification code sent to your registered email address.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.4)
                        : const Color.fromARGB(255, 103, 104, 107),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Pinput(
                  length: 4,
                  controller: controller,
                  onChanged: validateOtp,
                  separatorBuilder: (index) => const SizedBox(width: 6),
                  defaultPinTheme: defaultPinTheme,
                  showCursor: true,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(91, 76, 79, 85),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: MaterialButton(
                  hoverColor: const Color(0xffFF9A8C),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  height: 60,
                  onPressed: isOtpValid
                      ? () => verifyOtp(controller.text.trim())
                      : null,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xffC86B60)
                      : const Color(0xffFF9A8C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    'Submit',
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
                    'assets/images/vector 3.png',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xff3A6F73)
                        : const Color(0xffAED6DC),
                    height: 175,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
