class AudioBook {
  final int id;
  final String title;
  final String authorName;
  final String? narrator;
  final String? duration;
  final String? audioUrl;
  final String? coverImageUrl;

  AudioBook({
    required this.id,
    required this.title,
    required this.authorName,
    this.narrator,
    this.duration,
    this.audioUrl,
    this.coverImageUrl,
  });

  factory AudioBook.fromJson(Map<String, dynamic> json) {
    return AudioBook(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      authorName: json['creator'] ?? json['author'] ?? 'Unknown Author',
      narrator: json['narrator'],
      duration: json['duration'],
      audioUrl: json['streamUrl'],
      coverImageUrl: json['coverImageUrl'] ?? json['coverUrl'],
    );
  }

  get chapters => null;
}
