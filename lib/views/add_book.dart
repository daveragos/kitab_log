import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitablog/models/saved_book.dart';
import 'package:kitablog/services/db_helper.dart';
import 'package:kitablog/views/widgets/k_text_form_field.dart';

class AddBookScreen extends StatefulWidget {
  final Function onSave;

  const AddBookScreen({super.key, required this.onSave});

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();


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


  String _state = 'Planned';
  File? _selectedImage;


  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }


  Future<void> _saveBook() async {
    if (_formKey.currentState!.validate()) {

      SavedBook newBook = SavedBook(
        bookId: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        authors: _authorController.text,
        description: _descriptionController.text,
        pages: _pagesController.text,
        price: _priceController.text,
        rating: _ratingController.text,
        categories: _categoriesController.text,
        state: _state,
        imageUrl: _selectedImage != null ? _selectedImage!.path : ' ',
        publisher: _publisherController.text,
        publishedDate: _publishedDateController.text,
        isbn: _isbnController.text,
        language: _languageController.text,
        timestamp: DateTime.now().toIso8601String(),
      );


      await DBHelper().insertBookFromLocal(newBook);


      widget.onSave();


      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
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
                    const Expanded(
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
                  child: Column(
                    children: [
                      KTextFormField(
                        controller: _titleController,
                        label: 'Title',
                      ),
                      KTextFormField(
                        controller: _authorController,
                        label: 'Author(s)',
                      ),
                      KTextFormField(
                        controller: _descriptionController,
                        label: 'Description',
                        maxLines: 3,
                      ),
                      KTextFormField(
                        controller: _pagesController,
                        label:'Pages',
                        keyboardType: TextInputType.number,
                      ),
                      KTextFormField(
                        controller: _priceController,
                        label: 'Price',
                        keyboardType: TextInputType.number,
                      ),
                      KTextFormField(
                        controller: _ratingController,
                        label: 'Rating',
                        keyboardType: TextInputType.number,
                      ),
                      KTextFormField(
                        controller: _categoriesController,
                        label: 'Categories',
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
        ),
      ),
    );
  }
}
