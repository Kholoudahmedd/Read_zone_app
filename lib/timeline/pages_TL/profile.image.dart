import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/services/auth_service.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../model_TL/model_post.dart';
import '../widgets_TL/post_widget.dart';
import '../pages_TL/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  String? userImage;
  bool isLoading = true;

  final String baseUrl = 'https://myfirstapi.runasp.net/';

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  void loadUserProfile() async {
    final authService = AuthService();
    final profile = await authService.getProfile();

    if (!mounted) return;

    if (profile != null) {
      final profileImage = profile['profileImageUrl'];
      setState(() {
        username = profile['username'];
        email = profile['email'];
        userImage = profileImage != null && profileImage != ''
            ? '$baseUrl$profileImage'
            : null;
        isLoading = false;
      });
    } else {
      print("ERROR: Failed to load user profile");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: getRedColor(context)),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.grey),
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: innerBoxIsScrolled ? Text(username ?? '') : null,
              background: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/Subtract.png',
                        color: getitemColor(context),
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(0.0, -50.0, 0.0),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: (userImage != null &&
                                      userImage!.startsWith('http'))
                                  ? NetworkImage(userImage!)
                                  : const AssetImage('assets/images/test.jpg')
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            username ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            onPressed: () async {
                              final result =
                                  await Get.to(() => EditProfilePage());
                              if (result == true) {
                                loadUserProfile(); // إعادة تحميل البيانات بعد التحديث
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const SizedBox(),
              TabBar(
                dividerColor: Colors.transparent,
                labelColor: getRedColor(context),
                unselectedLabelColor: Colors.grey,
                indicatorColor: getRedColor(context),
                tabs: const [Tab(text: "Posts"), Tab(text: "Favourites")],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: dummyPosts
                          .where(
                              (post) => post.username == widget.user.username)
                          .length,
                      itemBuilder: (context, index) {
                        final userPosts = dummyPosts
                            .where(
                                (post) => post.username == widget.user.username)
                            .toList();
                        return PostWidget(
                          post: userPosts[index],
                          onDelete: () {},
                        );
                      },
                    ),
                    ListView.builder(
                      itemCount: widget.user.favorites.length,
                      itemBuilder: (context, index) {
                        return PostWidget(
                          post: widget.user.favorites[index],
                          onDelete: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
