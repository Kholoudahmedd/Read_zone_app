import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

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
