import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:read_zone_app/chat/screens/screenhome.dart';
import 'package:read_zone_app/screens/Settings.dart' as custom_settings;
import 'package:read_zone_app/screens/homepage_content.dart';
import 'package:read_zone_app/screens/library_content.dart';
import 'package:read_zone_app/screens/login_Screen.dart';
import 'package:read_zone_app/screens/notes_items.dart';
import 'package:read_zone_app/services/auth_service.dart';
import 'package:read_zone_app/store/main.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/timeline/model_TL/model_post.dart';
import 'package:read_zone_app/timeline/pages_TL/Timeline_page.dart';
import 'package:read_zone_app/timeline/pages_TL/profile.image.dart'
    show ProfilePage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:read_zone_app/screens/audio_books_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  final List<Widget> _tabs = [
    const HomepageContent(),
    const AudioBooksScreen(),
    const LibraryContent(),
    StoreHomepage(),
    TimelinePage(),
  ];

  bool isDarkMode = false;
  String? userImageHeader;
  bool isLoadingHeader = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _loadUserHeaderImage();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  void _toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
      Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  void _loadUserHeaderImage() async {
    final authService = AuthService();
    final profile = await authService.getProfile();

    if (!mounted) return;

    if (profile != null) {
      final profileImage = profile['profileImageUrl'];
      setState(() {
        userImageHeader = profileImage != null && profileImage != ''
            ? 'https://myfirstapi.runasp.net/$profileImage'
            : null;
        isLoadingHeader = false;
      });
    } else {
      setState(() {
        isLoadingHeader = false;
      });
    }
  }

  void onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void logout() async {
    final box = GetStorage();
    box.remove('token');
    Get.offAll(() => Loginscreen());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: selectedIndex == 3
            ? null
            : AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                actions: [
                  GestureDetector(
                    onTap: _toggleTheme,
                    child: Image.asset(
                      isDarkMode
                          ? 'assets/Dark/Group 4.png'
                          : 'assets/Dark/Group 3.png',
                      height: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(user: currentUser),
                          ),
                        );
                      },
                      child: isLoadingHeader
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: getRedColor(context)))
                          : CircleAvatar(
                              backgroundColor: getRedColor(context),
                              backgroundImage: userImageHeader != null
                                  ? NetworkImage(userImageHeader!)
                                  : const AssetImage('assets/images/test.jpg')
                                      as ImageProvider,
                            ),
                    ),
                  ),
                ],
              ),
        drawer: NavigationDrawer(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xff1E1E1E),
          children: [
            const UserHeader(),
            ListTile(
              title: Text('Home',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              leading: _buildIcon(context, 'assets/icon/Home_outlined.png'),
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Homepage()),
              ),
            ),
            ListTile(
              title: Text('Settings',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              leading: _buildIcon(context, 'assets/icon/settings.png'),
              onTap: () => Get.to(() => custom_settings.Settings()),
            ),
            ListTile(
              title: Text('Notification',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              leading: _buildIcon(context, 'assets/icon/notfication.png'),
            ),
            ListTile(
              title: Text('My Notes',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              leading: _buildIcon(context, 'assets/icon/notes.png'),
              onTap: () => Get.to(() => NotesItems()),
            ),
            ListTile(
              title: Text('Logout',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              leading: _buildIcon(context, 'assets/icon/logout.png'),
              onTap: () {
                Get.defaultDialog(
                  cancelTextColor: getTextColor2(context),
                  titleStyle: TextStyle(color: getTextColor2(context)),
                  middleTextStyle: TextStyle(color: getTextColor2(context)),
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xff1E1E1E)
                          : Colors.white,
                  title: "Logout",
                  middleText: "Are you sure you want to log out?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  buttonColor: getRedColor(context),
                  onConfirm: logout,
                  onCancel: () => Get.back(),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            PageStorage(
                bucket: _pageStorageBucket, child: _tabs[selectedIndex]),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/navbar_bg.png',
                height: MediaQuery.of(context).size.height * 0.09,
                fit: BoxFit.cover,
                color: isDarkMode
                    ? const Color(0xff3A6F73)
                    : const Color(0xffAED6DC),
              ),
            ),
            Positioned(
              bottom: 3,
              left: 5,
              right: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Get.to(ScreenHome()),
                    child: Image.asset(
                      isDarkMode
                          ? 'assets/Dark/Frame 34216.png'
                          : 'assets/icon/centerbtn.png',
                      height: 85,
                    ),
                  ),
                  NavBarIcon(
                      iconPath: 'assets/icon/home.png',
                      index: 0,
                      selectedIndex: selectedIndex,
                      onItemTapped: onTabSelected),
                  NavBarIcon(
                      iconPath: 'assets/icon/audio.png',
                      index: 1,
                      selectedIndex: selectedIndex,
                      onItemTapped: onTabSelected),
                  NavBarIcon(
                      iconPath: 'assets/icon/library.png',
                      index: 2,
                      selectedIndex: selectedIndex,
                      onItemTapped: onTabSelected),
                  NavBarIcon(
                      iconPath: 'assets/icon/store.png',
                      index: 3,
                      selectedIndex: selectedIndex,
                      onItemTapped: onTabSelected),
                  NavBarIcon(
                      iconPath: 'assets/icon/time line.png',
                      index: 4,
                      selectedIndex: selectedIndex,
                      onItemTapped: onTabSelected),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, String path) {
    return CircleAvatar(
      maxRadius: 15,
      minRadius: 15,
      backgroundColor: Colors.transparent,
      child: Image.asset(
        path,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xff4A536B),
        height: 30,
      ),
    );
  }
}

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
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
    return Container(
      height: 240,
      decoration: BoxDecoration(color: getitemColor(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading
              ? CircularProgressIndicator(
                  color: getRedColor(context),
                )
              : CircleAvatar(
                  backgroundColor: getRedColor(context),
                  backgroundImage: userImage != null
                      ? NetworkImage(userImage!)
                      : const AssetImage('assets/images/test.jpg')
                          as ImageProvider,
                  maxRadius: 80,
                ),
          const SizedBox(height: 10),
          Text(
            username ?? 'Loading...',
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email ?? '',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color.fromARGB(255, 205, 205, 205),
            ),
          ),
        ],
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final String iconPath;
  final int index;
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const NavBarIcon({
    super.key,
    required this.iconPath,
    required this.index,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onItemTapped(index),
      icon: Image.asset(
        iconPath,
        width: 41,
        color: Theme.of(context).brightness == Brightness.dark
            ? selectedIndex == index
                ? const Color.fromARGB(255, 32, 36, 46)
                : Colors.white
            : selectedIndex == index
                ? Colors.white
                : const Color(0xff4A536B),
      ),
    );
  }
}
