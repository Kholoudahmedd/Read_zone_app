class AudioBook {
  final int id;
  final String identifier;
  final String title;
  final String authorName;
  final String? narrator;
  final String? duration;
  final String? audioUrl;
  final String? coverImageUrl;

  AudioBook({
    required this.id,
    required this.identifier,
    required this.title,
    required this.authorName,
    this.narrator,
    this.duration,
    this.audioUrl,
    this.coverImageUrl,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return AudioBook(
      id: int.tryParse(json['id'].toString()) ?? 0,
      identifier: json['identifier'] ?? '',
      title: json['title'] ?? 'No Title',
      authorName: json['creator'] ?? json['author'] ?? 'Unknown Author',
      narrator: json['narrator'],
      duration: json['duration'],
      audioUrl: json['streamUrl'],
      coverImageUrl: json['coverImageUrl'] ?? json['coverUrl'],
    );
  }
}
