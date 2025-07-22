import '../model/book.dart';
import '../supabase_config.dart';

class BookService {
  static const String tableName = 'books';

  static Future<List<Book>> getBooks() async {
    final response = await SupabaseConfig.client
        .from(tableName)
        .select('*, categories:category_id (name)')
        .order('created_at', ascending: false);

    return (response as List).map((b) {
      final categoryName = (b['categories'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown';
      return Book.fromMap(b)..category = categoryName;
    }).toList();
  }

  static Future<List<Book>> getBooksByCategory(int categoryId) async {
    final response = await SupabaseConfig.client
        .from(tableName)
        .select('*, categories:category_id (name)')
        .eq('category_id', categoryId)
        .order('created_at', ascending: false);

    return (response as List).map((b) => Book.fromMap(b)).toList();
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await SupabaseConfig.client
        .from('categories')
        .select('*')
        .order('name');

    return (response as List).cast<Map<String, dynamic>>();
  }
}