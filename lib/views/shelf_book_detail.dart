import 'package:kitablog/models/saved_book.dart';
import 'package:kitablog/services/db_helper.dart';
import 'package:flutter/material.dart';

class ShelfBookDetail extends StatefulWidget {
  final SavedBook book; // Pass the Book object
  final Function onUpdate; // Add onUpdate callback

  const ShelfBookDetail({super.key, required this.book, required this.onUpdate});

  @override
  _ShelfBookDetailState createState() => _ShelfBookDetailState();
}

class _ShelfBookDetailState extends State<ShelfBookDetail> {
  late String _state;
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _authorsController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _ratingController;
  late TextEditingController _pagesController;
  late TextEditingController _languageController;
  late TextEditingController _isbnController;
  late TextEditingController _categoryController;
  late TextEditingController _publisherController;
  late TextEditingController _publishedDateController;
  late TextEditingController _timestampController;

  final _formKey = GlobalKey<FormState>();
  final DBHelper _dbHelper = DBHelper(); // DBHelper instance

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _subtitleController = TextEditingController(text: widget.book.subtitle);
    _authorsController = TextEditingController(text: widget.book.authors);
    _imageUrlController = TextEditingController(text: widget.book.imageUrl);
    _descriptionController = TextEditingController(text: widget.book.description);
    _priceController = TextEditingController(text: widget.book.price.toString());
    _ratingController = TextEditingController(text: widget.book.rating.toString());
    _pagesController = TextEditingController(text: widget.book.pages.toString());
    _languageController = TextEditingController(text: widget.book.language);
    _isbnController = TextEditingController(text: widget.book.isbn);
    _categoryController = TextEditingController(text: widget.book.categories);
    _publisherController = TextEditingController(text: widget.book.publisher);
    _publishedDateController = TextEditingController(text: widget.book.publishedDate);
    _timestampController = TextEditingController(text: widget.book.timestamp);
    _state = widget.book.state;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorsController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _isbnController.dispose();
    _categoryController.dispose();
    _publisherController.dispose();
    _publishedDateController.dispose();
    super.dispose();
  }

  // Update the book's information
  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      SavedBook updatedBook = SavedBook(
        id: widget.book.id,
        bookId: widget.book.bookId,
        title: _titleController.text,
        subtitle: _subtitleController.text,
        authors: _authorsController.text,
        imageUrl: _imageUrlController.text,
        description: _descriptionController.text,
        price: _priceController.text,
        rating: _ratingController.text,
        pages: _pagesController.text,
        language: _languageController.text,
        isbn: _isbnController.text,
        categories: _categoryController.text,
        publisher: _publisherController.text,
        publishedDate: _publishedDateController.text,
        timestamp: DateTime.now().toIso8601String(),
        state: _state,
      );

      await _dbHelper.updateReading(updatedBook); // Call update method
      widget.onUpdate(); // Notify the parent widget (if necessary)
      Navigator.pop(context); // Pop the page after updating
    }
  }
Future<void> _deleteBook() async {
  await _dbHelper.deleteReading(widget.book.id!); // Delete the book from DB
  widget.onUpdate(); // Call the onUpdate function to refresh the parent page
  Navigator.pop(context, true); // Pop the page and return true to indicate deletion
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteBook, // Delete the book
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _subtitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
              ),
              TextFormField(
                controller: _pagesController,
                decoration: const InputDecoration(labelText: 'Pages'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _languageController,
                decoration: const InputDecoration(labelText: 'Language'),
              ),
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(labelText: 'ISBN'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                controller: _publisherController,
                decoration: const InputDecoration(labelText: 'Publisher'),
              ),
              TextFormField(
                controller: _publishedDateController,
                decoration: const InputDecoration(labelText: 'Published Date'),
              ),
              DropdownButtonFormField<String>(
                value: _state,
                decoration: const InputDecoration(labelText: 'State'),
                items: ['Planned', 'Reading', 'Completed']
                    .map((state) => DropdownMenuItem<String>(
                          value: state,
                          child: Text(state),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _state = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBook, // Update book info
                child: const Text('Update Book Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
