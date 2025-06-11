import 'package:flutter/material.dart';
import 'package:read_zone_app/chat/screens/chatscreen.dart';
import 'package:read_zone_app/themes/colors.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final TextEditingController _controller = TextEditingController();

  void _startChat() {
    if (_controller.text.isNotEmpty) {
      String userMessage = _controller.text;
      _controller.clear();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(initialMessage: userMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: getGreenColor(context),
        title: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset('assets/images/RZ.png', fit: BoxFit.contain),
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Text(
                  'ChatRZ',
                  style: TextStyle(
                    color: getGreyColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'online',
                  style: TextStyle(
                    color: getRedColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/RZ.png', height: 200, width: 200),
                  SizedBox(height: 20),
                  Text(
                    'How can I help you today?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: getGreyColor(context),
                    ),
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
            TextField(
              controller: _controller,
              onSubmitted: (value) => _startChat(),
              decoration: InputDecoration(
                hintText: "Ask Something...",
                hintStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.edit, color: getRedColor(context)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: getRedColor(context)),
                  onPressed: _startChat,
                ),
                filled: true,
                fillColor: getitemColor(context),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 30),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
