class Character {
  final String title;
  final String releaseDate;
  final String description;
  final String cover;
  final String pages;
  final int index;

  Character({
    required this.title,
    required this.releaseDate,
    required this.description,
    required this.cover,
    required this.pages,
    required this.index,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      title: json['title'] ?? '-',
      releaseDate: json['releaseDate'] ?? '-',
      description: json['description'] ?? '-',
      cover: json['cover'] ?? '',
      pages: json['pages']?.toString() ?? '-',
      index: json['index'] ?? 0,
    );
  }
}
