import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // مكتبة التاريخ والوقت
import 'package:read_zone_app/themes/colors.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String initialMessage;
  ChatScreen({required this.initialMessage});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = []; // قائمة تخزن الرسائل
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      //  إضافة الرسالة الأولية للمحادثة
      messages.add({
        "text": widget.initialMessage,
        "isUser": true,
        "time": DateFormat('hh:mm a').format(DateTime.now()),
      });

      //  استدعاء الذكاء الاصطناعي للرد على الرسالة الأولية
      _getBotResponse(widget.initialMessage);
    }
  }

  //  دالة إرسال الرسالة
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        String time = DateFormat('hh:mm a').format(DateTime.now());
        messages.add({
          "text": _controller.text,
          "isUser": true,
          "time": time,
        });
      });

      String userMessage = _controller.text;
      _controller.clear();

      _getBotResponse(userMessage); //   لجلب رد الذكاء الاصطناعي
    }
  }

  //  دالة جلب رد الذكاء الاصطناعي
  Future<void> _getBotResponse(String message) async {
    String time = DateFormat('hh:mm a').format(DateTime.now());

    try {
      String botReply = await ApiService.getBotResponse(message);
      setState(() {
        messages.add({
          "text": botReply,
          "isUser": false,
          "time": time,
        });
      });
    } catch (e) {
      setState(() {
        messages.add({
          "text": " Server connection error!",
          "isUser": false,
          "time": time,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () {
           Get.toNamed('/home');
          },
        ),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg["isUser"]
                          ? getRedColor(context)
                          : getitemColor(context), //  لون مختلف حسب المرسل
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: msg["isUser"]
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg["text"], // عرض نص الرسالة
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          msg["time"], // عرض وقت الإرسال
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (value) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: "Ask Something...",
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.edit, color: getRedColor(context)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: getRedColor(context)),
                      onPressed: _sendMessage,
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
              ),
              // SizedBox(width: 8),
              // IconButton(
              //   icon: Icon(Icons.send, color: Color(0xffFF9A8D)), //
              //   onPressed: _sendMessage,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
