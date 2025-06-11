import 'package:flutter/material.dart';
import 'package:read_zone_app/data/models/grouped_book_model.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/business.dart';
import 'package:dio/dio.dart';

class BusinessSection extends StatefulWidget {
  const BusinessSection({super.key});

  @override
  State<BusinessSection> createState() => _BusinessSectionState();
}

class _BusinessSectionState extends State<BusinessSection> {
  List<BookModel> books = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response =
          await Dio().get('https://myfirstapi.runasp.net/api/Books/new');
      if (response.statusCode == 200) {
        final List data = response.data;
        if (mounted) {
          setState(() {
            books = data.map((book) => BookModel.fromJson(book)).toList();
            isLoading = false;
            isError = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      }
    } catch (e) {
      print('Error fetching books: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
          child: CircularProgressIndicator(
        color: getRedColor(context),
      ));
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'An error occurred while loading books.',
              style: TextStyle(color: getRedColor(context)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: fetchBooks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: getRedColor(context),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(color: getTextColor2(context)),
                )),
          ],
        ),
      );
    }

    if (books.isEmpty) {
      return const Center(child: Text("No books found."));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return BusinessWidget(book: books[index]);
      },
    );
  }
}
