class Book {
  final String id;
  final String title;
  final String author;
  final String? description;
  final String price;
  final int? categoryId;
  final String categoryName;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    required this.price,
    this.categoryId,
    required this.categoryName,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json["id"] as String,
      title: json["title"] as String,
      author: json["author"] as String,
      description: json["description"] as String?,
      price: json["price"] as String,
      categoryId: json["category_id"] as int?,
      categoryName: json["categories"] != null
          ? (json["categories"] as Map<String, dynamic>)["name"] as String
          : "Unknown",
    );
  }
}