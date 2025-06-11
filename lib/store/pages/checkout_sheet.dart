import 'package:flutter/material.dart';
import 'package:read_zone_app/store/pages/OrderAcceptedPage.dart';
import 'package:read_zone_app/themes/colors.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final double price;

  CheckoutBottomSheet({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Color(0xff4A536D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Checkout",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          //  خيارات الدفع والتوصيل
          _buildCheckoutOption("Delivery", "Select Method"),
          _buildCheckoutOption("Payment", "", imagepath: 'images/visa.png'),
          _buildCheckoutOption("Promo Code", "Pick discount"),

          //  السعر يتم تمريره من الموديل
          _buildCheckoutOption(
            "Total Cost",
            "\$$price",
          ),

          Spacer(),
          const Text.rich(
            TextSpan(
              text: "By placing an order you agree to our \n",
              style: TextStyle(fontSize: 14, ),
              children: [
                TextSpan(
                  text: "Terms And Conditions",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // مسافة قبل الزر

          //  زر الطلب
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: getRedColor(context),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderAcceptedPage()),
                );
              },
              child: Text("Place Order",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: getTextColor2(context))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutOption(String title, String value,
      {bool bold = false, IconData? icon, String? imagepath}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey)),
          Row(
            children: [
              if (imagepath != null)
                Image.asset(imagepath, width: 24, height: 24),
              if (icon != null) Icon(icon, size: 20, color: Colors.blue),
              SizedBox(width: (icon != null || imagepath != null) ? 5 : 0),
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: bold ? FontWeight.bold : FontWeight.w400,
                      )),
              Icon(Icons.arrow_forward_ios, size: 16, ),
            ],
          ),
        ],
      ),
    );
  }
}
