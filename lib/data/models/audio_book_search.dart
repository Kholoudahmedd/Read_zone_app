class SearchBook {
  final String title;
  final String identifier;
  final String creator;
  final String coverUrl;
  final String streamUrl;

  SearchBook({
    required this.title,
    required this.identifier,
    required this.creator,
    required this.coverUrl,
    required this.streamUrl,
  });

  factory SearchBook.fromJson(Map<String, dynamic> json) {
    return SearchBook(
      title: json['title'] ?? '',
      identifier: json['identifier'] ?? '',
      creator: json['creator'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      streamUrl: json['streamUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'identifier': identifier,
      'creator': creator,
      'coverUrl': coverUrl,
      'streamUrl': streamUrl,
    };
  }
}
