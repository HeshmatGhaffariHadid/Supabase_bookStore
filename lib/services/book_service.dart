import '../model/book.dart';
import '../supabase_config.dart';
import 'dart:core';

class BookService {
  static Future<List<Book>> getBooks() async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await SupabaseConfig.client
          .from('books')
          .select('*, categories!books_category_fk(name)')
          .order('title');
      return response.map((json) => Book.fromJson(json)).toList();
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - getBooks: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final stopwatch = Stopwatch()..start();
    try {
      return await SupabaseConfig.client
          .from('categories')
          .select()
          .order('name');
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - getCategories: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<void> addToFavorites(String bookId) async {
    final stopwatch = Stopwatch()..start();
    try {
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
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - addToFavorites: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<List<Book>> getFavorites() async {
    final stopwatch = Stopwatch()..start();
    try {
      final userId = SupabaseConfig.client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await SupabaseConfig.client
          .from('favorites')
          .select('books(*, categories!books_category_fk(name))')
          .eq('user_id', userId);

      return response.map((json) => Book.fromJson(json['books'])).toList();
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - getFavorites: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<List<Book>> getBooksByCategory(int categoryId) async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await SupabaseConfig.client
          .from('books')
          .select('*, categories!books_category_fk(name)')
          .eq('category_id', categoryId)
          .order('title');
      return response.map((json) => Book.fromJson(json)).toList();
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - getBooksByCategory: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<void> deleteFavorite(String bookId) async {
    final stopwatch = Stopwatch()..start();
    try {
      final userId = SupabaseConfig.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }
      await SupabaseConfig.client
          .from('favorites')
          .delete()
          .eq('book_id', bookId)
          .eq('user_id', userId);
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - deleteFavorite: ${stopwatch.elapsedMilliseconds} ms');
    }
  }

  static Future<void> addNewBook(Map<String, dynamic> bookData) async {
    final stopwatch = Stopwatch()..start();
    try {
      await SupabaseConfig.client
          .from('books')
          .insert(bookData);
    } finally {
      stopwatch.stop();
      print('🟡 SUPABASE_PERFORMANCE - addNewBook: ${stopwatch.elapsedMilliseconds} ms');
    }
  }
}