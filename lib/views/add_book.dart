import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitablog/models/saved_book.dart';
import 'package:kitablog/services/db_helper.dart';

class AddBookScreen extends StatefulWidget {
  final Function onSave;

  const AddBookScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _publishedDateController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _timestampController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  // Variables to store form values
  String _state = 'Planned'; // Default state
  File? _selectedImage;

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Method to save the book
  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {
      // Create a new SavedBook object
      SavedBook newBook = SavedBook(
        bookId: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        subtitle: _subtitleController.text ?? '',
        authors: _authorController.text,
        description: _descriptionController.text,
        pages: _pagesController.text ?? '0',
        price: _priceController.text ?? '0.0',
        rating: _ratingController.text ?? '0.0',
        categories: _categoriesController.text,
        state: _state,
        imageUrl: _selectedImage != null ? _selectedImage!.path : '', // Store the image path
        publisher: _publisherController.text,
        publishedDate: _publishedDateController.text,
        isbn: _isbnController.text,
        language: _languageController.text,
        timestamp: _timestampController.text,
      );

      // Save the book in the database
      await DBHelper().insertBook(newBook);

      // Call the onSave function to refresh the book list
      widget.onSave();

      // Close the add book screen
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Add New Book',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.save_sharp),
                        onPressed: () {
                          // Save the book in the database
                          _saveBook();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Book added to your shelf!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Author(s)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the author(s)';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pagesController,
                    decoration: const InputDecoration(labelText: 'Pages'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the number of pages';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ratingController,
                    decoration: const InputDecoration(labelText: 'Rating'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the rating';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _categoriesController,
                    decoration: const InputDecoration(labelText: 'Categories'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter categories';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _state,
                    decoration: const InputDecoration(labelText: 'State'),
                    items: const [
                      DropdownMenuItem(value: 'Planned', child: Text('Planned')),
                      DropdownMenuItem(value: 'Reading', child: Text('Reading')),
                      DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _state = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      if (_selectedImage != null)
                        Image.file(
                          _selectedImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Pick Image'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveBook,
                    child: const Text('Save Book'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
