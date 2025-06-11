import '../models/book_model.dart';

class BookService {
  static final List<Book> _mockBooks = [
    Book(
      id: "1",
      title: "Book of Night",
      author: "Holly Black",
      price: 200,
      imagepath: "images/image3.png",
      description:
          "The Catcher in the Rye is a novel by J. D. Salinger, partially published in serial form in 1945–1946 and as a novel in 1951. It was originally intended for adu lts but is often read by adolescents for its theme of angst, alienation and as a critique......",
    ),
    Book(
      id: "2",
      title: "Book of Night",
      author: "Holly Black",
      price: 200,
      imagepath: "images/image4.png",
      description:
          "The Catcher in the Rye is a novel by J. D. Salinger, partially published in serial form in 1945–1946 and as a novel in 1951. It was originally intended for adu lts but is often read by adolescents for its theme of angst, alienation and as a critique......",
    ),
    Book(
      id: "2",
      title: "Book of Night",
      author: "Holly Black",
      price: 200,
      imagepath: "images/image5.png",
      description:
          "The Catcher in the Rye is a novel by J. D. Salinger, partially published in serial form in 1945–1946 and as a novel in 1951. It was originally intended for adu lts but is often read by adolescents for its theme of angst, alienation and as a critique......",
    ),
  ];

  Future<List<Book>> fetchBooks() async {
    await Future.delayed(
      Duration(seconds: 2),
      
    );

    return _mockBooks;
  }
}
