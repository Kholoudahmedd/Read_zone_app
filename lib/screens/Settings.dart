import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/services/auth_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/timeline/pages_TL/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    setState(() => _isDarkMode = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    Get.changeThemeMode(_isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _changePassword() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final confirm = await Get.dialog(
      Dialog(
        backgroundColor: getitemColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Change Your Password',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Divider(),
              const SizedBox(height: 20),
              PasswordField(
                  controller: currentPasswordController,
                  hintText: 'Current Password'),
              const SizedBox(height: 10),
              PasswordField(
                  controller: newPasswordController, hintText: 'New Password'),
              const SizedBox(height: 10),
              PasswordField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: getRedColor(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: Text('Set Password',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      final currentPassword = currentPasswordController.text.trim();
      final newPassword = newPasswordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (currentPassword.isEmpty ||
          newPassword.isEmpty ||
          confirmPassword.isEmpty) {
        Get.snackbar('Error', 'All fields are required.');
        return;
      }

      if (newPassword.length < 6) {
        Get.snackbar('Error', 'Password must be at least 6 characters.');
        return;
      }

      if (newPassword != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match.');
        return;
      }

      final success = await AuthService().changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        Get.snackbar('Success', 'Password changed successfully.');
      } else {
        Get.snackbar('Error', 'Failed to change password.');
      }
    }
  }

  Future<void> deleteUserAccount() async {
    final success = await AuthService().deleteAccount();
    if (success) {
      Get.snackbar('Deleted', 'Account deleted successfully.');
      Get.offAllNamed('/login');
    } else {
      Get.snackbar('Error', 'Failed to delete account.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        _isDarkMode || Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/Dark/Rectangle 4.png',
                color: isDarkMode
                    ? const Color(0xffC86B60)
                    : const Color(0xffFFCCC6),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.settings, color: getRedColor(context), size: 40),
                    Text(
                      'Settings',
                      style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: getRedColor(context)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              _buildSettingOption(context,
                  icon: Icons.edit,
                  text: ' Edit Profile',
                  onTap: () {
                    Get.to(() => EditProfilePage(),
                        transition: Transition.fade,
                        duration: Duration(milliseconds: 300));
                  }),
              SizedBox(height: 20),
              _buildSettingOption(context,
                  icon: Icons.lock_outline,
                  text: ' Change Password',
                  onTap: _changePassword),
              SizedBox(height: 20),
              _buildSettingOption(context,
                  icon: Icons.dark_mode,
                  text: ' Dark Mode',
                  switchValue: _isDarkMode,
                  onSwitchChanged: _toggleTheme),
              SizedBox(height: 20),
              _buildSettingOption(context,
                  icon: Icons.notifications_active,
                  text: ' Notifications',
                  switchValue: false,
                  onSwitchChanged: (value) {}),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  final confirmDelete = await Get.dialog(
                        AlertDialog(
                          backgroundColor: isDarkMode
                              ? const Color(0xff1E1E1E)
                              : Colors.white,
                          title: const Text('Delete Account'),
                          content: const Text(
                              'Are you sure you want to delete your account? This action cannot be undone.'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(result: false),
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: getRedColor(context)))),
                            TextButton(
                                onPressed: () => Get.back(result: true),
                                child: Text('Confirm',
                                    style: TextStyle(
                                        color: getRedColor(context)))),
                          ],
                        ),
                      ) ??
                      false;
                  if (confirmDelete) deleteUserAccount();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: getRedColor(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text('Delete Account',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: getTextColor2(context))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context,
      {required IconData icon,
      required String text,
      bool switchValue = false,
      Function(bool)? onSwitchChanged,
      VoidCallback? onTap}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xffC86B60) : const Color(0xffFFCCC6),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, color: getGreyColor(context)),
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: getGreyColor(context))),
          Spacer(),
          if (onSwitchChanged != null)
            Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: getTextColor2(context)),
          if (onTap != null)
            GestureDetector(
                onTap: onTap,
                child: Icon(Icons.arrow_forward_ios,
                    color: getGreyColor(context))),
        ],
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordField(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
