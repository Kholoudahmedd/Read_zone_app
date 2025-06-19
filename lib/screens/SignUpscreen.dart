import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:read_zone_app/screens/login_Screen.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/text_fields.dart';
import 'package:dio/dio.dart';

class Signupscreen extends StatefulWidget {
  Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  String? email;
  String? password;
  String? confirmpassword;
  String? username;
  DateTime? dateOfBirth;
  bool isloading = false;

  final Dio dio = Dio();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: CircularProgressIndicator(
        color: Color(0xffFF9A8C),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Center(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 170),
                      child: Column(
                        children: [
                          Text(
                            'Sign Up',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Create New Account',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white.withOpacity(0.4)
                                  : Color.fromARGB(136, 74, 83, 109),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFields(
                            onchanged: (data) {
                              username = data;
                            },
                            hintText: 'Username...',
                            icon: Icon(Icons.person_outline_rounded),
                            obtext: false,
                          ),
                          const SizedBox(height: 10),
                          TextFields(
                            onchanged: (data) {
                              email = data;
                            },
                            hintText: 'Email...',
                            icon: Icon(Icons.email_outlined),
                            obtext: false,
                          ),
                          const SizedBox(height: 10),
                          TextFields(
                            onchanged: (data) {
                              password = data;
                            },
                            hintText: 'Password...',
                            icon: Icon(Icons.lock_outline),
                            obtext: true,
                          ),
                          const SizedBox(height: 10),
                          TextFields(
                            onchanged: (data) {
                              confirmpassword = data;
                            },
                            hintText: 'Confirm Password...',
                            icon: Icon(Icons.lock_outline),
                            obtext: true,
                            validator: (data) {
                              if (data == null || data.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (data != password) {
                                return 'Passwords doesn\'t match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 385,
                            child: DateTimeFormField(
                              validator: (data) {
                                if (data == null) {
                                  return 'This Field is Required';
                                }
                                return null;
                              },
                              hideDefaultSuffixIcon: true,
                              dateFormat: DateFormat('dd/MM/yyyy'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: getTextColor2(context),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Date Of Birth...',
                                prefixIcon: Icon(Icons.date_range_outlined),
                                hintStyle: GoogleFonts.inter(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.4)
                                      : Color(0XFFA4A9B5),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide:
                                      BorderSide(color: Color(0XFFA4A9B5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2),
                                  borderSide:
                                      BorderSide(color: Color(0XFFA4A9B5)),
                                ),
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              firstDate: DateTime(DateTime.now().year - 100),
                              lastDate: DateTime.now(),
                              initialPickerDateTime:
                                  DateTime(DateTime.now().year),
                              onChanged: (DateTime? value) {
                                dateOfBirth = value;
                              },
                            ),
                          ),
                          const SizedBox(height: 25),
                          MaterialButton(
                            hoverColor: Color(0xffFF9A8C),
                            minWidth: MediaQuery.of(context).size.width * 0.9,
                            height: 60,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });

                                try {
                                  final response = await dio.post(
                                    'https://myfirstapi.runasp.net/api/auth/register',
                                    data: {
                                      'username': username,
                                      'email': email,
                                      'password': password,
                                      'profileImageUrl': '',
                                      'birthDate':
                                          dateOfBirth?.toIso8601String(),
                                    },
                                  );

                                  if (response.statusCode == 200 ||
                                      response.statusCode == 201) {
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: 'Your Account has been registered',
                                      confirmBtnText: 'Login',
                                      onConfirmBtnTap: () {
                                        Get.to(
                                          () => const Loginscreen(),
                                          transition: Transition.fadeIn,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      },
                                      customAsset: 'assets/images/g14.png',
                                      title: 'Congratulations!',
                                      titleColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                      textColor: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Color(0xff1E1E1E)
                                              : Colors.white,
                                      confirmBtnColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Color(0xffC86B60)
                                              : Color(0xffFF9A8C),
                                    );
                                  } else {
                                    print(
                                        "❌ فشل تسجيل المستخدم: ${response.statusCode}");
                                    Get.snackbar(
                                      'Registration Failed',
                                      'Failed to register: ${response.statusCode}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      
                                      colorText: Colors.white,
                                    );
                                  }
                                } catch (e) {
                                  if (e is DioException && e.response != null) {
                                    print("❌ API Error: ${e.response!.data}");
                                    Get.snackbar(
                                      'Error',
                                      '${e.response!.data}',
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.white,
                                    );
                                  } else {
                                    print("❌ Unexpected Error: $e");
                                    Get.snackbar(
                                      'Unexpected Error',
                                      '$e',
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText: Colors.white,
                                    );
                                  }
                                }

                                setState(() {
                                  isloading = false;
                                });
                              }
                            },
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Color(0xffC86B60)
                                    : Color(0xffFF9A8C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white.withOpacity(0.4)
                                      : Color.fromARGB(136, 74, 83, 109),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => const Loginscreen(),
                                    transition: Transition.fadeIn,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                child: Text(
                                  "Login here",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Vector 1.png',
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xff3A6F73)
                    : Color(0xffAED6DC),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 30,
              right: 30,
              child: Image.asset(
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? 'assets/Dark/5098292 2.png'
                    : 'assets/images/g13.png',
                height: 210,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
