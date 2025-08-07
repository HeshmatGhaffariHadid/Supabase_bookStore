import 'package:flutter/material.dart';
import 'package:supabase_v/pages/details_page.dart';
import 'package:supabase_v/services/book_service.dart';
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
      final favoriteBooks = await BookService.getFavorites();
      setState(() {
        books = favoriteBooks;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading favorites: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> deleteBook(Book book) async {
    try {
      await BookService.deleteFavorite(book.id);
      await _loadFavorites();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Favorites')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: books.isEmpty
            ? const Center(
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
            child: const Icon(Icons.book, color: primaryColor, size: 38),
          ),
          title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.author, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                '\$${book.price}',
                style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
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
              'category': book.categoryName,
              'price': book.price,
            },
          ),
        ),
      ),
    );
  }
}

