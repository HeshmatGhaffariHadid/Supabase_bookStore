import '../model/book.dart';
import '../supabase_config.dart';

class BookService {
  static const String tableName = 'books';

  // Get all books sorted by creation date
  static Future<List<Book>> getBooks() async {
    final response = await SupabaseConfig.client
        .from(tableName)
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((b) => Book.fromMap(b)).toList();
  }

  // Get books by category
  static Future<List<Book>> getBooksByCategory(String category) async {
    final response = await SupabaseConfig.client
        .from(tableName)
        .select()
        .eq('category', category)
        .order('created_at', ascending: false);
    return (response as List).map((b) => Book.fromMap(b)).toList();
  }

  // Get all unique categories
  static Future<List<String>> getCategories() async {
    final response = await SupabaseConfig.client
        .from(tableName)
        .select('category');
    final categories = (response as List)
        .map((item) => item['category'] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    return categories..sort();
  }
}