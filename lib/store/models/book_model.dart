class Book {
  final int id;
  final String title;
  final String coverImageUrl;
  final String author; // ناخد أول اسم فقط من القائمة
  final double price;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.author,
    required this.price,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    print("📚 JSON Authors: ${json['authors']}");

    return Book(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      //coverImageUrl: json['coverImageUrl'] ?? '',
      coverImageUrl: (json['coverImageUrl'] ?? '').trim(),

      author: json['authorName'] ?? 'Unknown',

      price: (json['price'] as num?)?.toDouble() ?? 0.0, // حتى لو لسه مش موجود
      description: json['description'] ?? '', // حتى لو مش موجود حاليا
    );
  }
}
