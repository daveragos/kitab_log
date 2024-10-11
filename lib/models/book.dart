// class Book {
//   final String subtitle;
//   final String title;
//   final int? id;
//   final String authors;
//   final String description;
//   final String price;
//   final String isbn;
//   final String publisher;
//   final String publishedDate;
//   final String language;
//   final String pages;
//   final String rating;
//   final String imageUrl;
//   final String category;
//   final String state;

//   const Book({
//     this.id,
//     required this.subtitle,
//     required this.title,
//     required this.authors,
//     required this.description,
//     required this.price,
//     required this.isbn,
//     required this.publisher,
//     required this.publishedDate,
//     required this.language,
//     required this.state,
//     required this.pages,
//     required this.rating,
//     required this.imageUrl,
//     required this.category,
//   });

//   // Method to return a new Book instance with updated fields
//   Book copyWith({
//     String? subtitle,
//     String? title,
//     int? id,
//     String? authors,
//     String? description,
//     String? price,
//     String? isbn,
//     String? publisher,
//     String? publishedDate,
//     String? language,
//     String? pages,
//     String? rating,
//     String? imageUrl,
//     String? category,
//     String? state,
//   }) {
//     return Book(
//       subtitle: subtitle ?? this.subtitle,
//       title: title ?? this.title,
//       id: id ?? this.id,
//       authors: authors ?? this.authors,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       isbn: isbn ?? this.isbn,
//       publisher: publisher ?? this.publisher,
//       publishedDate: publishedDate ?? this.publishedDate,
//       language: language ?? this.language,
//       pages: pages ?? this.pages,
//       rating: rating ?? this.rating,
//       imageUrl: imageUrl ?? this.imageUrl,
//       category: category ?? this.category,
//       state: state ?? this.state,
//     );
//   }
//  factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       title: json['volumeInfo']['title'] ?? 'No Title',
//       subtitle: json['volumeInfo']['subtitle'] ?? '',
//       authors: (json['volumeInfo']['authors'] as List<dynamic>?)?.join(', ') ?? 'Unknown',
//       description: json['volumeInfo']['description'] ?? '',
//       imageUrl: json['volumeInfo']['imageLinks']?['thumbnail'] ?? 'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY',
//       publishedDate: json['volumeInfo']['publishedDate'] ?? '',
//       isbn: (json['volumeInfo']['industryIdentifiers'] != null &&
//               json['volumeInfo']['industryIdentifiers'].isNotEmpty)
//           ? json['volumeInfo']['industryIdentifiers'][0]['identifier']
//           : 'No ISBN',
//       publisher: json['volumeInfo']['publisher'] ?? 'Unknown',
//       pages: json['volumeInfo']['pageCount'] ?? 0,
//       category: (json['volumeInfo']['categories'] != null &&
//               json['volumeInfo']['categories'].isNotEmpty)
//           ? json['volumeInfo']['categories'][0]
//           : 'Unknown',
//       price: '0',
//       language: 'English',
//       rating: '0',
//       state: 'Available',
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'id': subtitle,
//       'authors': authors,
//       'publisher': publisher,
//       'isbn': isbn,
//       'publishedDate': publishedDate,
//       'pages': pages,
//       'description': description,
//       'price': price,
//       'language': language,
//       'rating': rating,
//       'imageUrl': imageUrl,
//       'category': category,
//     };


//   }

//   }