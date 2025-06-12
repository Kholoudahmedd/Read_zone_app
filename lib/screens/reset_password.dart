import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/widgets/text_fields.dart';
import 'package:read_zone_app/screens/login_screen.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPassword({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.post(
        'https://myfirstapi.runasp.net/api/Auth/reset-password',
        data: {
          "email": widget.email,
          "otp": widget.otp,
          "newPassword": newPassword,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password has been reset successfully");
        Get.offAll(() => const Loginscreen());
      } else {
        Get.snackbar("Error", "Failed to reset password");
      }
    } on DioException catch (e) {
      String error = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        error = e.response?.data.toString() ?? error;
      }
      Get.snackbar("Error", error);
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
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Center(
              child: Image.asset(
                'assets/images/tdesign_user-password.png',
                height: 110,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 80),
            TextFields(
              controller: newPasswordController,
              hintText: "New password...",
              icon: const Icon(Icons.lock_outline),
              obtext: true,
            ),
            const SizedBox(height: 10),
            TextFields(
              controller: confirmPasswordController,
              hintText: "Confirm new password...",
              icon: const Icon(Icons.lock_outline),
              obtext: true,
            ),
            const SizedBox(height: 50),
            MaterialButton(
              hoverColor: const Color(0xffFF9A8C),
              minWidth: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              onPressed: resetPassword,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffC86B60)
                  : const Color(0xffFF9A8C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                'Reset Password',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.13),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/vector 3.png',
                  height: 175,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xff3A6F73)
                      : const Color(0xffAED6DC),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
