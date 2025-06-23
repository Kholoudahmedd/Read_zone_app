import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read_zone_app/screens/Homepage.dart';
import 'package:read_zone_app/themes/colors.dart';

class OrderAcceptedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, getRedColor(context)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/accepted.png", width: 150),
            SizedBox(height: 20),
            Text(
              "Your Order has been\naccepted",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Your items have been placed and\nare on their way to being processed",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Get.to(Homepage(),
                    transition: Transition.fadeIn,
                    duration: Duration(milliseconds: 300));
              },
              child: Text("Back to home",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
