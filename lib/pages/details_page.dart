import 'package:flutter/material.dart';
import 'package:supabase_v/services/book_service.dart';
import '../constants.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = '/details';

  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (routeArguments == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Book Details')),
        body: const Center(child: Text('No book data provided')),
      );
    }

    final bookTitle = routeArguments['title'] ?? 'No title provided';
    final bookAuthor = routeArguments['author'] ?? 'No author found';
    final bookDescription = routeArguments['description'] ?? 'No description provided';
    final bookCategory = routeArguments['category'] ?? 'Unknown';
    final bookPrice = routeArguments['price'] ?? '0';
    final bookId = routeArguments['id'];

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 240,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(Icons.book, size: 100, color: primaryColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                bookTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bookAuthor,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Category: $bookCategory',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Row(
                children: [
                  const Text('Rating: ', style: TextStyle(fontSize: 18)),
                  _buildStars(4.5),
                  const SizedBox(width: 8),
                  const Text('4.5 (1,234 reviews)'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Price', style: TextStyle(color: Colors.grey[700])),
              Text(
                '\$$bookPrice',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bookDescription,
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      setState(() {
                        isAdding = true;
                      });
                      if (bookId != null) {
                        await BookService.addToFavorites(bookId.toString());
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Added to favorites')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    } finally {
                      setState(() {
                        isAdding = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    backgroundColor: Colors.indigo[400],
                    foregroundColor: Colors.white,
                  ),
                  child: isAdding ? CircularProgressIndicator(color: Colors.white, strokeWidth: 1) : Text('Add to Favorites', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_half,
          color: Colors.orangeAccent,
          size: 20,
        );
      }),
    );
  }
}

