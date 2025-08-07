import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/book.dart';
import '../supabase_config.dart';

class BookService {
  static Future<List<Book>> getBooks() async {
    final response = await SupabaseConfig.client
        .from('books')
        .select('*, categories!books_category_fk(name)')
        .order('title');
    return response.map((json) => Book.fromJson(json)).toList();
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    return await SupabaseConfig.client
        .from('categories')
        .select()
        .order('name');
  }

  static Future<void> addToFavorites(String bookId) async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    await SupabaseConfig.client
        .from('favorites')
        .upsert({
      'book_id': bookId,
      'user_id': userId,
    });
  }

  static Future<List<Book>> getFavorites() async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await SupabaseConfig.client
        .from('favorites')
        .select('books(*, categories!books_category_fk(name))')
        .eq('user_id', userId);

    return response.map((json) => Book.fromJson(json['books'])).toList();
  }

  static Future<List<Book>> getBooksByCategory(int categoryId) async {
    final response = await SupabaseConfig.client
        .from('books')
        .select('*, categories!books_category_fk(name)')
        .eq('category_id', categoryId)
        .order('title');
    return response.map((json) => Book.fromJson(json)).toList();
  }

  static Future<void> deleteFavorite(String bookId) async {
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }
    await SupabaseConfig.client
        .from('favorites')
        .delete()
        .eq('book_id', bookId)
        .eq('user_id', userId);
  }
}
