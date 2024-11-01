
class SavedBook {
  final int? id;
  final String bookId;
  final String title;
  final String? subtitle;
  final String language;
  final String pages;
  final String price;
  final String rating;
  final String categories;
  final String publisher;
  final String publishedDate;
  final String isbn;
  final String authors;
  final String imageUrl;
  final String description;
  final String state;
  final String timestamp;

  SavedBook({
    this.id,
    required this.bookId,
    required this.title,
    this.subtitle,
    required this.language,
    required this.pages,
    required this.price,
    required this.rating,
    required this.categories,
    required this.publisher,
    required this.publishedDate,
    required this.isbn,
    required this.authors,
    required this.imageUrl,
    required this.description,
    required this.state,
    required this.timestamp,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'title': title,
      'subtitle': subtitle,
      'language': language,
      'pages': pages,
      'price': price,
      'rating': rating,
      'categories': categories,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'isbn': isbn,
      'authors': authors,
      'imageUrl': imageUrl,
      'description': description,
      'state': state,
      'timestamp': timestamp,
    };
  }


  factory SavedBook.fromMap(Map<String, dynamic> book) {
    return SavedBook(
      id: book['id'],
      bookId: book['bookId'],
      title: book['title'],
      subtitle: book['subtitle'],
      language: book['language'],
      pages: book['pages'],
      price: book['price'],
      rating: book['rating'],
      categories: book['categories'],
      publisher: book['publisher'],
      publishedDate: book['publishedDate'],
      isbn: book['isbn'],
      authors: book['authors'],
      imageUrl: book['imageUrl'],
      description: book['description'],
      state: book['state'],
      timestamp: book['timestamp'],
    );
  }

}
