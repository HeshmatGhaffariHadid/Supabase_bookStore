import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_v/pages/Category_list.dart';
import 'package:supabase_v/pages/signin_signup_pages/signIn_page.dart';
import 'package:supabase_v/supabase_config.dart';
import 'package:supabase_v/services/book_service.dart';
import '../constants.dart';
import '../model/book.dart';
import 'details_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routName = '/homePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final titleNode = FocusNode();
  final authorNode = FocusNode();
  final descNode = FocusNode();
  final pricesNode = FocusNode();

  List<Book> books = [];
  late List<String> categories = ['Science', 'Programming', 'Art', 'Literature'];
  bool isLoading = true;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      // Load books with category names
      final books = await BookService.getBooks();

      // Load categories
      final categoriesData = await BookService.getCategories();
      final categoryNames = categoriesData.map((c) => c['name'] as String).toList();

      setState(() {
        this.books = books;
        this.categories = categoryNames;
      });

    } catch (e) {
      print('Error loading data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () async {
              await SupabaseConfig.client.auth.signOut();
              Navigator.pushReplacementNamed(context, SignInPage.routeName);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.indigo,
              ),
              onPressed: () => Navigator.pushNamed(context, FavoritesPage.routeName),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Books',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return _buildFeaturedBook(context, books[index]);
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Popular Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildCategory('Science', Icons.science_outlined),
                _buildCategory('Programming', Icons.computer),
                _buildCategory('Art', Icons.palette),
                _buildCategory('Literature', Icons.menu_book),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,
        child: const Icon(Icons.add, color: Colors.indigo, size: 30),
      ),
    );
  }

  Future<void> _showBottomSheet() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 420,
          padding: const EdgeInsets.all(16),
          child: Expanded(
            child: Column(
              children: [
                Text(
                  'Add New Book',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: titleController,
                  label: 'Book Title',
                  node: titleNode,
                  nextNode: authorNode,
                ),
                _buildTextField(
                  controller: authorController,
                  label: 'Author Name',
                  node: authorNode,
                  nextNode: descNode,
                ),
                _buildTextField(
                  controller: descriptionController,
                  label: 'Description',
                  node: descNode,
                  nextNode: pricesNode,
                ),
                _buildTextField(
                  controller: priceController,
                  label: 'Price',
                  node: pricesNode,
                ),
                const SizedBox(height: 16),
                _buildCategoryDropdown(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: _addNewBook,
                        child: const Text('Add Book'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map((category) => DropdownMenuItem(
        value: category,
        child: Text(category),
      ))
          .toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value;
        });
      },
      validator: (value) =>
      value == null ? 'Please select a category' : null,
    );
  }

  // Future<void> _showNewCategoryDialog() async {
  //   final newCategory = await showDialog<String>(
  //     context: context,
  //     builder: (context) {
  //       final controller = TextEditingController();
  //       return AlertDialog(
  //         title: const Text('New Category'),
  //         content: TextField(
  //           controller: controller,
  //           decoration: const InputDecoration(
  //             labelText: 'Category Name',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel', style: TextStyle(color: Colors.red),),
  //           ),
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, controller.text),
  //             child: const Text('Create'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   if (newCategory != null && newCategory.isNotEmpty) {
  //     setState(() {
  //       selectedCategory = newCategory;
  //       if (!categories.contains(newCategory)) {
  //         categories.add(newCategory);
  //         categories.sort();
  //       }
  //     });
  //   }
  // }

  Future<void> _addNewBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        priceController.text.isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    try {
      // First get the category ID from the category name
      final categoryResponse = await SupabaseConfig.client
          .from('categories')
          .select('id')
          .eq('name', selectedCategory!)
          .single();

      final categoryId = categoryResponse['id'] as int;

      // Create book object with proper category_id
      final newBook = {
        'title': titleController.text,
        'author': authorController.text,
        'description': descriptionController.text,
        'price': priceController.text,
        'category_id': categoryId,
      };

      // Insert into Supabase
      final response = await SupabaseConfig.client
          .from('books')
          .insert(newBook)
          .select()
          .single();

      print('Book added successfully: $response');

      // Clear form
      titleController.clear();
      authorController.clear();
      descriptionController.clear();
      priceController.clear();
      setState(() => selectedCategory = null);

      // Refresh data
      await _loadData();
      if (mounted) Navigator.pop(context);

    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database error: ${e.message}')),
      );
    } catch (e) {
      print('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding book: ${e.toString()}')),
      );
    }
  }

  TextField _buildTextField({
    required TextEditingController controller,
    required String label,
    required FocusNode node,
    FocusNode? nextNode,
  }) {
    return TextField(
      focusNode: node,
      controller: controller,
      textInputAction: nextNode != null ? TextInputAction.next : TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.indigo, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12)
      ),
      onSubmitted: (_) => FocusScope.of(context).requestFocus(nextNode),
    );
  }

  Widget _buildFeaturedBook(BuildContext context, Book book) {

    String categoryName;
    try {
      categoryName = categories[book.categoryId - 1];
    } catch (e) {
      categoryName = 'Unknown';
    }

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        DetailsPage.routeName,
        arguments: {
          'id': book.id,
          'title': book.title,
          'author': book.author,
          'description': book.description,
          'category': categoryName,
          'price': book.price,
        },
      ),
      child: Card(
        elevation: 4,
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(Icons.book, size: 60, color: primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              FittedBox(
                child: Text(
                  book.author,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${book.price}',
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCategory(String name, IconData icon) {
    final count = books.where((b) => b.category == name).length;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        CategoryList.routeName,
        arguments: {'category': name},
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '$count ${count == 1 ? 'book' : 'books'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}