import 'package:flutter/material.dart';
import 'package:read_zone_app/store/pages/book_detail_page.dart';
import 'package:read_zone_app/themes/colors.dart';
import '../models/book_model.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final int index;

  const BookCard({Key? key, required this.book, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color frameColor = index.isEven ? getRedColor(context) : getGreenColor(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        //الإطار الرئيسية
        Container(
          width: 130,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding:
              const EdgeInsets.only(top: 50, bottom: 12, left: 8, right: 8),
          decoration: BoxDecoration(
            color: frameColor, //  استخدام نفس اللون للإطار والزر
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80), // يترك مساحة للصورة فوق الإطار
              Text(
                book.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              //  السعر واسم الكاتب
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${book.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: getGreyColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // يخنصر اسم لو طويل ب...
                      maxLines: 1, // يمنع كسر الاسم إلى سطر جديد
                      softWrap: false, //  يمنع أي كسر تلقائي للنص
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        //غلاف الكتاب
        Positioned(
          top: -10,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                book.imagepath,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        //  زر (+) داخل الإطار بلون مطابق
        Positioned(
          bottom: 5,
          right: 5,
          child: Material(
            color: Colors.transparent, //  يمنع أي خلفية غير مرغوبة
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), //   ظل
                    blurRadius: 6,
                    spreadRadius: 2, // توزيع الظل
                    offset: Offset(2, 2), //  اتجاه الظل
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: frameColor,
                radius: 16,
                child: IconButton(
                  padding: EdgeInsets.zero, // يمنع أي مسافات داخل الزر
                  icon: Icon(Icons.add, color: Colors.white, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailPage(book: book),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
