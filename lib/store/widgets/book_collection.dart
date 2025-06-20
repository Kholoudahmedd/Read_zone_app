import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';

class BookCollectionPage extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BookCollectionPage({required this.title, required this.books, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title, //  عنوان القسم
          style: TextStyle(
              color: getRedColor(context), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 7,
          ),
          itemCount: books.length,

          //    books.length < 5 ? 30 : books.length, //  تكرار القائمة عند الحاجة
          itemBuilder: (context, index) {
            return Center(
              child: BookCard(
                book: books[index],

                //book: books[index % books.length], //  تكرار عند الحاجة
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }
}
