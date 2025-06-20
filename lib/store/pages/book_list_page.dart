// import 'package:flutter/material.dart';
// import '../services/book_service.dart';
// import '../widgets/book_section.dart';

// class BookListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final books =
//         BookService().fetchBooks(); // جلب الكتب مرة واحدة لتجنب التكرار
//     return SliverList(
//       delegate: SliverChildListDelegate(
//         [
//           BookSection(title: "Top Sellers", books: books),
//           BookSection(title: "New Arrivals", books: books),
//           BookSection(title: "Special Offers", books: books),
//           SizedBox(
//             height: 100,
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../widgets/book_section.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          BookSection(
            title: "Top Sellers",
            books: BookService().fetchTopSellers(),
          ),
          BookSection(
            title: "New Arrivals",
            books: BookService().fetchNewArrivals(),
          ),
          BookSection(
            title: "Special Offers",
            books: BookService().fetchSpecialOffers(),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
