class NewArrival {
  final int id;
  final String title;
  final String authorName;
  final String coverImageUrl;
  final List<String> subjects;
  final double rating;
  final double price;
  final String description;

  NewArrival({
    required this.id,
    required this.title,
    required this.authorName,
    required this.coverImageUrl,
    required this.subjects,
    required this.rating,
    required this.price,
    required this.description,
  });

  factory NewArrival.fromJson(Map<String, dynamic> json) {
    return NewArrival(
      id: json['id'],
      title: json['title'],
      authorName: json['authorName'],
      coverImageUrl: json['coverImageUrl'],
      subjects: List<String>.from(json['subjects']),
      rating: (json['rating'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authorName': authorName,
      'coverImageUrl': coverImageUrl,
      'subjects': subjects,
      'rating': rating,
      'price': price,
      'description': description,
    };
  }
}
