class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String price;
  final int categoryId;
  final DateTime createdAt;
  String? category; // Add this field

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.createdAt,
    this.category,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      description: map['description'] as String,
      price: map['price'] as String,
      categoryId: map['category_id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'category_id': categoryId,
    };
  }
}