import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserService extends GetxController {
  var username = ''.obs;
  var email = ''.obs;

  Future<void> fetchUserData() async {
    try {
      final dio = Dio();
      final response =
          await dio.get('https://myfirstapi.runasp.net/api/auth/profile');

      if (response.statusCode == 200) {
        username.value = response.data['username'];
        email.value = response.data['email'];
        
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
