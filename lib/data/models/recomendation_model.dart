class Recommendation {
  final String title;
  final String author;

  Recommendation({
    required this.title,
    required this.author,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
    };
  }
}
