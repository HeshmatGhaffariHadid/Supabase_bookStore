import 'package:supabase_v/model/book.dart';

class Categories{
  static List<Book> science = [Book(
    title: 'Physics Secrets',
    author: 'Albert Anstine',
    description:
    'Learning Physics is quite Complex if you choose other books as your main reference in the your learning world',
    category: 'science',
    price: '20.3',
  ),];
  static List<Book> art = [
    Book(
      title: 'Singing',
      author: 'Ada Lunsalan',
      description:
      'Learning singing is quite simple if you choose this book as your main reference in the your coding world',
      category: 'art',
      price: '17.9',
    ),
  ];
  static List<Book> programming = [Book(
    title: 'Learn Algorithm',
    author: 'Gang of Four',
    description:
    'The most popular and efficient algorithms are described in this valuable book',
    category: 'programming',
    price: '49.9',
  ),];
  static List<Book> literature = [
    Book(
      title: 'Arabic',
      author: 'Musa Mashal',
      description:
      'Arabic is the most historical and powerful language of the world, about all significant science books are written in Arabic, it is the early Islam language and the holy Quran is written in Arabic',
      category: 'Literature',
      price: '49.9',
    ),
  ];


}