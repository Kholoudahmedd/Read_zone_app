// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pinput/pinput.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:read_zone_app/screens/login_Screen.dart';

// class EmailVerificationScreen extends StatefulWidget {
//   final String email;

//   const EmailVerificationScreen({Key? key, required this.email})
//       : super(key: key);

//   @override
//   _EmailVerificationScreenState createState() =>
//       _EmailVerificationScreenState();
// }

// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final controller = TextEditingController();
//   bool isOtpValid = false;

//   void validateOtp(String otp) {
//     setState(() {
//       isOtpValid = otp.length == 4;
//     });
//   }

//   Future<void> verifyOtpWithApi() async {
//     try {
//       final dio = Dio();
//       final response = await dio.post(
//         'https://myfirstapi.runasp.net/api/Auth/verify-otp',
//         data: {
//           'email': widget.email,
//           'otp': controller.text.trim(),
//         },
//       );

//       if (response.statusCode == 200) {
//         QuickAlert.show(
//           context: context,
//           type: QuickAlertType.success,
//           text: 'Your account has been verified successfully',
//           confirmBtnText: 'Continue',
//           onConfirmBtnTap: () {
//             Get.to(
//               () => const Loginscreen(),
//               transition: Transition.fadeIn,
//               duration: const Duration(milliseconds: 300),
//             );
//           },
//           customAsset: 'assets/images/g14.png',
//           title: 'Congratulations!',
//           titleColor: Theme.of(context).brightness == Brightness.dark
//               ? Colors.white
//               : Colors.black,
//           textColor: Theme.of(context).brightness == Brightness.dark
//               ? Colors.white
//               : Colors.black,
//           backgroundColor: Theme.of(context).brightness == Brightness.dark
//               ? const Color(0xff1E1E1E)
//               : Colors.white,
//           confirmBtnColor: Theme.of(context).brightness == Brightness.dark
//               ? const Color(0xffC86B60)
//               : const Color(0xffFF9A8C),
//         );
//       }
//     } on DioException catch (e) {
//       String errorMessage = "Something went wrong.";
//       if (e.response != null && e.response?.data != null) {
//         errorMessage = e.response?.data.toString() ?? errorMessage;
//       }
//       Get.snackbar(
//         "Error",
//         errorMessage,
//         snackPosition: SnackPosition.BOTTOM,
//         colorText: Colors.white,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 64,
//       textStyle: GoogleFonts.inter(
//         fontSize: 20,
//         color: const Color.fromARGB(255, 0, 0, 0),
//       ),
//       decoration: const BoxDecoration(
//         color: Color(0XFFA4A9B5),
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//       ),
//     );

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         scrolledUnderElevation: 0,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: MediaQuery.of(context).size.height * 0.15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, right: 10),
//                 child: Text(
//                   'Verify Email',
//                   style: GoogleFonts.inter(
//                     fontSize: 32,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 30, right: 20, top: 30),
//                 child: Text(
//                   'Enter the 4-digit code sent to your email address.',
//                   style: GoogleFonts.inter(
//                     fontSize: 14,
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? Colors.white.withOpacity(0.4)
//                         : const Color.fromARGB(255, 103, 104, 107),
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Container(
//                 width: 450,
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Center(
//                   child: Pinput(
//                     length: 4,
//                     controller: controller,
//                     onChanged: validateOtp,
//                     separatorBuilder: (index) => const SizedBox(width: 15),
//                     defaultPinTheme: defaultPinTheme,
//                     showCursor: true,
//                     focusedPinTheme: defaultPinTheme.copyWith(
//                       decoration: const BoxDecoration(
//                         color: Color.fromARGB(91, 76, 79, 85),
//                         borderRadius: BorderRadius.all(Radius.circular(8)),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               Center(
//                 child: MaterialButton(
//                   hoverColor: const Color(0xffFF9A8C),
//                   minWidth: MediaQuery.of(context).size.width * 0.9,
//                   height: 60,
//                   onPressed: isOtpValid ? verifyOtpWithApi : null,
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? const Color(0xffC86B60)
//                       : const Color(0xffFF9A8C),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   child: Text(
//                     'Verify',
//                     style: GoogleFonts.inter(
//                       fontSize: 26,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.2),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Image.asset(
//                     'assets/images/vector 3.png',
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? const Color(0xff3A6F73)
//                         : const Color(0xffAED6DC),
//                     height: 175,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
