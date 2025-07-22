import 'package:flutter/material.dart';
import 'package:supabase_v/pages/details_page.dart';
import 'package:supabase_v/supabase_config.dart';
import '../constants.dart';
import '../model/book.dart';

class FavoritesPage extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Book> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);
    try {
      final response = await SupabaseConfig.client
          .from('favorites')
          .select('''
            books (
              id,
              title,
              author,
              description,
              category,
              price
            )
          ''');

      setState(() {
        books = (response as List)
            .map((fav) => Book.fromMap(fav['books']))
            .toList();
      });
    } catch (e) {
      print('Error loading favorites: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      if (book.id != null) {
        await SupabaseConfig.client
            .from('favorites')
            .delete()
            .eq('book_id', book.id!);

        _loadFavorites();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: books.isEmpty
            ? Center(
          child: Text(
            'There are no books in your favorites!',
            style: TextStyle(color: Colors.indigo, fontSize: 20),
          ),
        )
            : ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return _buildFavoriteItem(context, book);
          },
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Book book) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: Container(
            width: 50,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[400],
            ),
            child: Icon(Icons.book, color: primaryColor, size: 38),
          ),
          title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.author, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                '\$${book.price}',
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteBook(book),
          ),
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
      ),
    );
  }
}