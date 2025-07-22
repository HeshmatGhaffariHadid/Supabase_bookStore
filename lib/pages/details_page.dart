import 'package:flutter/material.dart';
import 'package:supabase_v/supabase_config.dart';
import 'package:supabase_v/services/book_service.dart';
import '../constants.dart';
import '../model/book.dart';

class DetailsPage extends StatelessWidget {
  static const routeName = '/details';

  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final bookTitle = routeArguments['title'];
    final bookAuthor = routeArguments['author'];
    final bookDescription = routeArguments['description'];
    final bookCategory = routeArguments['category'];
    final bookPrice = routeArguments['price'];
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
                  child: Icon(Icons.book, size: 100, color: primaryColor),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                bookTitle ?? 'No title provided',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bookAuthor ?? 'No author found',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Category: $bookCategory',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Row(
                children: [
                  Text('Rating: ', style: TextStyle(fontSize: 18)),
                  _buildStars(4.5),
                  const SizedBox(width: 8),
                  const Text('4.5 (1,234 reviews)'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Price', style: TextStyle(color: Colors.grey[700])),
              Text(
                '\$$bookPrice',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bookDescription ?? 'No description provided',
                style: TextStyle(height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final bookId = routeArguments['id'];
                      if (bookId != null) {
                        await SupabaseConfig.client
                            .from('favorites')
                            .insert({'book_id': bookId});

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to favorites')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    backgroundColor: Colors.indigo[400],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add to Favorites', style: TextStyle(fontSize: 18)),
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