// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:read_zone_app/Notfication/monitor.dart';
import 'package:read_zone_app/screens/homepage.dart';
import 'package:read_zone_app/screens/login_screen.dart';
import 'package:read_zone_app/screens/on_boarding.dart';
import 'package:read_zone_app/screens/welcome_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();

  bool isFirstRun = box.read('isFirstRun') ?? true;
  if (isFirstRun) {
    await box.write('isFirstRun', false);
  }

  bool isLoggedIn = box.read('token') != null;

  final monitor = NotificationMonitor();

  runApp(ReadZoneApp(
    isFirstRun: isFirstRun,
    isLoggedIn: isLoggedIn,
    onAppReady: monitor.start,
  ));
}

class ReadZoneApp extends StatelessWidget {
  final bool isFirstRun;
  final bool isLoggedIn;
  final VoidCallback onAppReady;

  const ReadZoneApp({
    super.key,
    required this.isFirstRun,
    required this.isLoggedIn,
    required this.onAppReady,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => onAppReady());

    return ScreenUtilInit(
      designSize: const Size(400, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Read Zone',
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: ThemeMode.system,
          initialRoute: _getInitialRoute(),
          getPages: _getAppRoutes(),
          defaultTransition: Transition.fadeIn,
        );
      },
    );
  }

  String _getInitialRoute() {
    if (isLoggedIn) return '/home';
    if (isFirstRun) return '/onboarding';
    return '/welcome';
  }

  List<GetPage> _getAppRoutes() => [
        GetPage(name: '/home', page: () => const Homepage()),
        GetPage(name: '/onboarding', page: () => const OnBoarding()),
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const Loginscreen()),
      ];

  ThemeData _buildLightTheme() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: Colors.blue[800]!,
          secondary: Colors.blueAccent,
        ),
      );

  ThemeData _buildDarkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff1E1E1E),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.lightBlueAccent,
        ),
      );
}
