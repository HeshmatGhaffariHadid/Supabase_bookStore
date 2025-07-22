
import 'book.dart';
class FavStorage {
  static final List<Book> favorites = [];

  static void addFavorite(Book book) {
    favorites.add(book);
  }

  static void removeBook(Book book) {
    favorites.remove(book);
  }
}
