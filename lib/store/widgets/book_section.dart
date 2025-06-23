import 'package:flutter/material.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../models/book_model.dart';
import '../widgets/book_card.dart';
import '../widgets/book_collection.dart';

class BookSection extends StatelessWidget {
  final String title;
  final Future<List<Book>> books;

  const BookSection({
    Key? key,
    required this.title,
    required this.books,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title, //  يتغير حسب القسم (Top Sellers / New Arrivals / Special Offers)
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final bookList = await books;

                  //  توليد قائمة مكررة لضمان التكرار داخل صفحة See All//من اول هنا هحذف
                  List<Book> repeatedBooks = [];
                  while (repeatedBooks.length < 15) {
                    // تكرار القائمة على الأقل 15 مرة
                    repeatedBooks.addAll(bookList);
                  }
                  // repeatedBooks =
                  //   repeatedBooks.sublist(0, 15); // التأكد أن العدد 15 فقط
                  //من هنا هيتحذف لما api
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookCollectionPage(title: title, books: bookList),
                    ),
                  );
                },
                child: Text(
                  "See All >",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getGreyColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),

        //  عرض الكتب بشكل أفقي
        SizedBox(
          height: 250,
          child: FutureBuilder<List<Book>>(
            future: books,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: getRedColor(context),
                ));
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("An error occurred while loading books"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No books available"));
              }

              List<Book> bookList = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(15, (index) {
                    //  تكرار لا نهائي مؤقتًا (15 كتاب على الأقل)
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 150,
                        child: BookCard(
                          book: bookList[index %
                              bookList
                                  .length], //  تدوير الكتب عند انتهاء القائمة
                          index: index,
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
