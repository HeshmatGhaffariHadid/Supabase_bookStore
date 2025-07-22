
import 'package:supabase_v/model/categories.dart';
import 'book.dart';
class FavStorage {
  static final List<Book> favorites = [
    Categories.art[0],
  ];

  static void addFavorite(Book book) {
    favorites.add(book);
  }

  static void removeBook(Book book) {
    favorites.remove(book);
  }
}
