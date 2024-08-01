class BookModel {
  String id;
  String title;
  String description;
  String category;
  String? bookUrl;
  String? bookCoverUrl;
  BookModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.category,
    required this.bookUrl,
    required this.bookCoverUrl,
  });
}
