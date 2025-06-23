import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import 'package:get_storage/get_storage.dart';

class OrderService {
  final String baseUrl = 'https://myfirstapi.runasp.net/api/Orders';
  final box = GetStorage();

  /// إرسال طلب شراء
  Future<bool> submitOrder({
    required int bookId,
    required String fullName,
    required String mobileNumber,
    required String address,
    required int quantity,
  }) async {
    final token = box.read('token');
    if (token == null) {
      print(" Token not found, user not logged in.");
      return false;
    }

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "bookId": bookId,
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "address": address,
        "quantity": quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Order submitted successfully");
      return true;
    } else {
      print("❌ Failed to submit order: ${response.statusCode}");
      return false;
    }
  }

  /// (اختياري) جلب جميع الطلبات
  Future<List<dynamic>> fetchMyOrders() async {
    final token = box.read('token');
    if (token == null) return [];

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to fetch orders");
    }
  }
}

class BookService {
  final String baseUrl = 'https://myfirstapi.runasp.net/api/Store';

  Future<List<Book>> fetchTopSellers() async {
    return _fetchBooks('$baseUrl/topsellers');
  }

  Future<List<Book>> fetchNewArrivals() async {
    return _fetchBooks('$baseUrl/newarrivals');
  }

  Future<List<Book>> fetchSpecialOffers() async {
    return _fetchBooks('$baseUrl/specialoffers');
  }

  Future<Book> fetchBookById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/book/$id'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Book.fromJson(jsonData);
    } else {
      throw Exception('Failed to load book');
    }
  }

  Future<List<Book>> _fetchBooks(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books from $url');
    }
  }
}
