import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/book_model.dart';

import 'OrderAcceptedPage.dart';
import 'package:read_zone_app/themes/colors.dart';

class PurchaseBookScreen extends StatefulWidget {
  final Book book;

  const PurchaseBookScreen({super.key, required this.book});

  @override
  State<PurchaseBookScreen> createState() => _PurchaseBookScreenState();
}

class _PurchaseBookScreenState extends State<PurchaseBookScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  int quantity = 1;
  bool isSubmitted = false;

  Future<void> submitOrder() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final token = GetStorage().read('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in first.')),
      );
      return;
    }

    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("https://myfirstapi.runasp.net/api/Orders"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "bookId": widget.book.id,
        "fullName": name,
        "mobileNumber": phone,
        "address": address,
        "quantity": quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {
        isSubmitted = true;
      });

      // بعد ثانيتين ينتقل لصفحة تأكيد الطلب
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderAcceptedPage()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order.')),
      );
    }
  }

  InputDecoration customInputDecoration(BuildContext context) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: getRedColor(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: getRedColor(context), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: Text("Purchase Book"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Text(
              "Book: ${book.title}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("Full Name"),
            TextField(
              controller: nameController,
              decoration: customInputDecoration(context),
            ),
            SizedBox(height: 20),
            Text("Mobile Number"),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: customInputDecoration(context),
            ),
            SizedBox(height: 20),
            Text("Address"),
            TextField(
              controller: addressController,
              decoration: customInputDecoration(context),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: getRedColor(context),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Order Book Now",
                style: TextStyle(color: Colors.black), // النص أسود دائمًا
              ),
            ),
            SizedBox(height: 20),
            if (isSubmitted)
              Row(
                children: [
                  Icon(Icons.check_circle, color: getRedColor(context)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Your order has been placed successfully!",
                      style: TextStyle(
                        color: getRedColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
