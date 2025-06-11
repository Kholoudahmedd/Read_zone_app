import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/widgets/text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_zone_app/screens/login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key, required String email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
              onPressed: () async {
                final newPassword = newPasswordController.text.trim();
                final confirmPassword = confirmPasswordController.text.trim();

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                  return;
                }

                if (newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Password must be at least 6 characters')),
                  );
                  return;
                }

                try {
                  await FirebaseAuth.instance.currentUser!
                      .updatePassword(newPassword);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password updated successfully')),
                  );

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loginscreen()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
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
