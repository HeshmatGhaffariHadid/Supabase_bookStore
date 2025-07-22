class Book {
  final String? id;
  final String title;
  final String author;
  final String description;
  final String category; // Changed to non-nullable
  final String price;
  final DateTime? createdAt;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.category, // Now required
    required this.price,
    this.createdAt,
  });

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id']?.toString(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Uncategorized', // Default value
      price: map['price']?.toString() ?? '0.0',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'category': category,
      'price': price,
      if (id != null) 'id': id,
    };
  }
}