import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:read_zone_app/themes/colors.dart';
import 'package:read_zone_app/widgets/newarrival_items.dart';

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({super.key});

  @override
  State<RecommendationSection> createState() => _RecommendationSectionState();
}

class _RecommendationSectionState extends State<RecommendationSection> {
  List<Map<String, dynamic>> recommendations = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response =
          await Dio().get('https://myfirstapi.runasp.net/api/AudioBooks/home');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (mounted) {
          setState(() {
            recommendations = data.map<Map<String, dynamic>>((book) {
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
      print('Error fetching recommendations: $e');
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
              'An error occurred while loading recommendations.',
              style: TextStyle(color: getRedColor(context)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: fetchRecommendations,
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
        return NewarrivalItems(bookData: recommendations[index]);
      },
    );
  }
}
