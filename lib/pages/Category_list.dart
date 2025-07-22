import 'package:flutter/material.dart';

import '../model/book.dart';
import '../services/book_service.dart';
import '../supabase_config.dart';
import 'details_page.dart';

class CategoryList extends StatefulWidget {
  static const routeName = '/category-list';

  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late String category;
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    category = ModalRoute.of(context)?.settings.arguments as String? ?? 'Uncategorized';
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => isLoading = true);
    try {
      // First get category ID
      final categoryResponse = await SupabaseConfig.client
          .from('categories')
          .select('id')
          .eq('name', category)
          .single();

      final categoryId = categoryResponse['id'] as int;

      // Then get books by category ID
      books = await BookService.getBooksByCategory(categoryId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading books: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
          ? Center(
        child: Text(
          'No books in $category category',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: const Icon(Icons.book, size: 40),
              title: Text(book.title),
              subtitle: Text(book.author),
              trailing: Text('\$${book.price}'),
              onTap: () => Navigator.pushNamed(
                context,
                DetailsPage.routeName,
                arguments: {
                  'id': book.id,
                  'title': book.title,
                  'author': book.author,
                  'description': book.description,
                  'category': book.category,
                  'price': book.price,
                },
              ),
            ),
          );
        },
      ),
    );
  }
}