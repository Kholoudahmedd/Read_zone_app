import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:read_zone_app/screens/update_profile.dart';
import 'package:read_zone_app/themes/colors.dart';

class ProfilePage1 extends StatefulWidget {
  const ProfilePage1({super.key});

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  late Future<Map<String, String>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserProfile();
  }

  Future<Map<String, String>> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return {
        'userName': doc['username'] ?? 'Unknown User',
        'userEmail': doc['email'] ?? 'No Email',
        'userImage': doc.data().toString().contains('profileImage')
            ? doc['profileImage']
            : 'assets/images/test.jpg',
      };
    } else {
      return {
        'userName': 'User not found',
        'userEmail': 'No Email',
        'userImage': 'assets/images/test.jpg',
      };
    }
  }

  void _refreshUserData() {
    setState(() {
      _userDataFuture = _loadUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, String>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: getRedColor(context)));
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return Center(child: Text('Erorr please try again.'));
          }

          final userData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/Subtract.png',
                      width: double.infinity,
                      color: getitemColor(context),
                    ),
                    Positioned(
                      top: 30,
                      left: 10,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: getTextColor2(context),
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: getGreenColor(context),
                  radius: 110,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 107,
                    backgroundImage: userData['userImage'] != null &&
                            userData['userImage']!.startsWith('http')
                        ? NetworkImage(userData['userImage']!)
                        : AssetImage('assets/images/test.jpg') as ImageProvider,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  userData['userName']!,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    color: getTextColor2(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  userData['userEmail']!,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: getGreyColor(context),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: () async {
                    final updated = await Get.to(() => UpdateProfilePage());
                    if (updated == true) {
                      _refreshUserData();
                    }
                  },
                  child: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  color: getitemColor(context),
                  minWidth: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
