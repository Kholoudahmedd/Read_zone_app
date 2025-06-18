import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/newarrival_items.dart';

class science extends StatefulWidget {
  const science({super.key});

  @override
  State<science> createState() => _scienceState();
}

class _scienceState extends State<science> {
  List<Map<String, dynamic>> sciences = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchsciences();
  }

  Future<void> fetchsciences() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await Dio()
          .get('https://myfirstapi.runasp.net/api/books/sections/science');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (mounted) {
          setState(() {
            sciences = data.map<Map<String, dynamic>>((book) {
              return {
                "id": book["id"],
                "title": book["title"],
                "author": book["authorName"],
                "rating": book["rating"].toString(),
                "image": book["coverImageUrl"],
                "category": book["subjects"] ?? '',
              };
            }).toList();
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
      print('Error fetching sciences: $e');
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
        ),
      );
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
              onPressed: fetchsciences,
              style: ElevatedButton.styleFrom(
                backgroundColor: getRedColor(context),
              ),
              child: Text(
                'Retry',
                style: TextStyle(color: getTextColor2(context)),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return NewarrivalItems(bookData: sciences[index]);
      },
    );
  }
}
