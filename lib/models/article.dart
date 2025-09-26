// lib/models/article.dart

class Article {
  final String title;
  final String category;
  final String imageUrl;
  final String content;
  final DateTime date;
  bool isBookmarked;
  bool isFavorite;

  Article({
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.content,
    required this.date,
    this.isBookmarked = false,
    this.isFavorite = false,
  });
}



