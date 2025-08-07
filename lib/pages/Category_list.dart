import 'package:flutter/material.dart';
import 'package:supabase_v/constants.dart';
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
  String category = '';
  List<Book> books = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    category = args?['category'] ?? 'Uncategorized';
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => isLoading = true);
    try {
      final categoryResponse =
          await SupabaseConfig.client
              .from('categories')
              .select('id')
              .eq('name', category)
              .single();

      final categoryId = categoryResponse['id'] as int;
      final booksData = await BookService.getBooksByCategory(categoryId);

      setState(() {
        books = booksData;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading books: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : books.isEmpty
              ? Center(
                child: Text(
                  'No books in $category category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                            child: const Icon(
                              Icons.book,
                              size: 44,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        title: Text(
                          book.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(book.author),
                        trailing: Text('\$${book.price}', style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),),
                        onTap:
                            () => Navigator.pushNamed(
                              context,
                              DetailsPage.routeName,
                              arguments: {
                                'id': book.id,
                                'title': book.title,
                                'author': book.author,
                                'description': book.description,
                                'category': book.categoryName,
                                'price': book.price,
                              },
                            ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
