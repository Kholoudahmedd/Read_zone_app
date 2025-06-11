import 'package:flutter/material.dart';
import 'constants_TL.dart';
import 'pages_TL/Timeline_page.dart';

void main() {
  runApp(TimelineApp());
}

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class TimelineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Timeline",
          theme: ThemeData(
            primaryColor: lightprimaryColor,
            secondaryHeaderColor: lightsecondaryColor,
            scaffoldBackgroundColor: lightbackground,
            textTheme: TextTheme(bodyMedium: TextStyle(color: lightfont)),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: lightprimaryColor),
              titleTextStyle: TextStyle(
                color: lightprimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              fillColor: lightcommentfield,
              filled: true,
            ),
            cardColor: lightprofilepage,
          ),
          // darkTheme: ThemeData(
          //   primaryColor: darkprimaryColor,
          //   secondaryHeaderColor: darksecondaryColor,
          //   scaffoldBackgroundColor: const Color(0xff1E1E1E),
          //   textTheme: TextTheme(bodyMedium: TextStyle(color: darkfont)),
          //   appBarTheme: AppBarTheme(
          //     backgroundColor: darkbackground,
          //     elevation: 0,
          //     iconTheme: IconThemeData(color: darkprimaryColor),
          //     titleTextStyle: TextStyle(
          //       color: darkprimaryColor,
          //       fontSize: 20,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   inputDecorationTheme: InputDecorationTheme(
          //     fillColor: darkcommentfield,
          //     filled: true,
          //   ),
          //   cardColor: darkprofilepage,
          // ),
          themeMode: currentTheme,
          home: TimelinePage(),
        );
      },
    );
  }
}
