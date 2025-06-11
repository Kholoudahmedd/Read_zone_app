class BookContent {
  final String title;
  final String content;
  final int id;
  BookContent({
    required this.title,
    required this.content,
    required this.id,
  });

  factory BookContent.fromJson(Map<String, dynamic> json) {
    return BookContent(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'id': id,
    };
  }
}
