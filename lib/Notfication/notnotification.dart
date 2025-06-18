import 'package:flutter/material.dart';

class NoNotificationPage extends StatelessWidget {
  const NoNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // صورة توضيحية (تغير حسب الثيم)
            SizedBox(
              width: 300,
              child:
                  Image.asset(isDark ? 'images/dark.png' : 'images/light.png'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
