class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String imagepath;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imagepath,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imagepath: json['imagepath'],
      description: json['description'],
    );
  }
}
