import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:read_zone_app/screens/Homepage.dart';
import 'package:read_zone_app/screens/SignUpscreen.dart';
import 'package:read_zone_app/screens/forget_password.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/text_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_zone_app/services/auth_service.dart'; // تأكد أنك أنشأته

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool isloading = false;
  bool rememberMe = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: EdgeInsets.all(20),
        elevation: 20,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
        content: Text(message),
      ),
    );
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        _showSnackBar('Please enter email and password.');
        return;
      }

      setState(() => isloading = true);

      final success = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        await _saveCredentials();
        Get.to(() => const Homepage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 300));
      } else {
        _showSnackBar('Invalid email or password. Please try again.');
      }

      setState(() => isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: CircularProgressIndicator(color: Color(0xffFF9A8C)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Image.asset(
            'assets/images/Vector 2.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.29,
            color: Theme.of(context).brightness == Brightness.dark
                ? Color(0xff3A6F73)
                : Color(0xffAED6DC),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 10,
            child: Image.asset(
              MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? 'assets/Dark/g10.png'
                  : 'assets/images/login.png',
              height: 300,
            ),
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 330),
                    Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Text('Welcome Back!',
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ))),
                    Text(
                      'Login to Your Account',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.4)
                            : Color.fromARGB(136, 74, 83, 109),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFields(
                      controller: emailController,
                      hintText: 'Email...',
                      icon: Icon(Icons.person_outline_rounded),
                      obtext: false,
                    ),
                    SizedBox(height: 10),
                    TextFields(
                      controller: passwordController,
                      hintText: 'Password....',
                      icon: Icon(Icons.lock_outline),
                      obtext: true,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                rememberMe = !rememberMe;
                              });
                              await prefs.setBool('rememberMe', rememberMe);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: rememberMe
                                      ? getRedColor(context)
                                      : Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Container(
                                width: 21,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: rememberMe
                                      ? getRedColor(context)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Remember me',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const ForgetPassword(),
                                  transition: Transition.fadeIn,
                                  duration: const Duration(milliseconds: 300));
                            },
                            child: Text(
                              'Forget Password?',
                              style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: getRedColor(context),
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    MaterialButton(
                      hoverColor: Color(0xffFF9A8C),
                      minWidth: MediaQuery.of(context).size.width * 0.9,
                      height: 60,
                      onPressed: _login,
                      color: getRedColor(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Text('Login',
                          style: GoogleFonts.inter(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.4)
                                    : Color.fromARGB(136, 74, 83, 109),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(
                              () => Signupscreen(),
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 300),
                            );
                          },
                          child: Text(
                            " Sign Up",
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
