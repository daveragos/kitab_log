import 'package:kitablog/models/saved_book.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize the database
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'reading.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE readings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId TEXT,
        title TEXT,
        subtitle TEXT,
        language TEXT,
        pages TEXT,
        price TEXT,
        rating TEXT,
        categories TEXT,
        publisher TEXT,
        publishedDate TEXT,
        isbn TEXT,
        authors TEXT,
        imageUrl TEXT,
        description TEXT,
        state TEXT DEFAULT 'Planned',  -- Add state column
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertReading(Book book) async {
  final db = await database;
  final bookInfo = book.volumeInfo;

String categories = bookInfo.categories != null ? bookInfo.categories.join(', ') : '';
  String authors = bookInfo.authors != null ? bookInfo.authors.join(', ') : '';

  // Download the image and get the local path
  String imageUrl = bookInfo.imageLinks?['thumbnail'].toString() ?? '';
  String localImagePath = imageUrl.isNotEmpty
      ? await _downloadImage(imageUrl, book.id)
      : 'https://lh3.googleusercontent.com/proxy/4z1e5tJL9nhsfFc6X3jsElJ_xOvo1uuiiCb5J_qdv7ZjOw5J4bzP1E3FdFbYBlvQpcIs7kgXC2xcKovRP-L2cGEop_IXbL3P1SauzTkY';  // Default if no image is available.

  return await db.insert('readings', {
    'bookId': book.id ?? '',
    'title': bookInfo.title ?? '',
    'subtitle': bookInfo.subtitle ?? '',
    'language': bookInfo.language ?? '',
    'pages': bookInfo.pageCount.toString() ?? '',

    'price': '0',
    'rating': bookInfo.averageRating.toString() ?? '',
    'categories': categories ?? '',
    'publisher': bookInfo.publisher ?? '',
    'publishedDate': bookInfo.publishedDate?.toIso8601String() ?? '',
    'isbn': bookInfo.industryIdentifiers[0].identifier ?? '',
    'authors': authors ?? '',
    'imageUrl': localImagePath ?? '',  // Store local image path instead of URL.
    'description': bookInfo.description ?? '',
    'state': 'Planned',
    'timestamp': DateTime.now().toIso8601String(),
  });
}


  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE readings ADD COLUMN bookId TEXT');
    }
  }

Future<int> insertBook(SavedBook book) async {
  final db = await database;
  return await db.insert(
    'books',
    book.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

  // Update book state
  Future<int> updateReadingState(int id, String newState) async {
    final db = await database;
    return await db.update(
      'readings',
      {'state': newState},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateReading(SavedBook book) async {
  final db = await database;
  return await db.update(
    'readings',
    {
      'bookId': book.id,
      'title': book.title,
      'subtitle': book.subtitle,
      'authors': book.authors,
      'imageUrl': book.imageUrl,  // Store local image path.
      'description': book.description,
      'state': book.state,
      'price': '0',
      'rating': book.rating,
      'pages': book.pages,
      'language': book.language,
      'isbn': book.isbn,
      'categories': book.categories,
      'publisher': book.publisher,
      'publishedDate': book.publishedDate,
      'timestamp': DateTime.now().toIso8601String(),
    },
    where: 'id = ?',
    whereArgs: [book.id],
  );
}


  Future<int> deleteReading(int id) async {
  final db = await database;

  // Fetch the book to delete and get the image path.
  final book = await db.query('readings', where: 'id = ?', whereArgs: [id]);
  if (book.isNotEmpty) {
    final imagePath = book[0]['imageUrl'];
    // Delete the image file if it exists.
    final file = File(imagePath.toString());
    if (await file.exists()) {
      await file.delete();
    }
  }

  return await db.delete(
    'readings',
    where: 'id = ?',
    whereArgs: [id],
  );
}


  // Get all readings
  Future<List<Map<String, dynamic>>> getReadings() async {
    final db = await database;
    return await db.query('readings');
  }
}


Future<String> _downloadImage(String url, String bookId) async {
  try {
    // Get the document directory to save images.
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$bookId.jpg';

    // Download the image.
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);

    // Save the image to local storage.
    await file.writeAsBytes(response.bodyBytes);

    return filePath; // Return the local path of the saved image.
  } catch (e) {
    print('Error downloading image: $e');
    return ''; // Return empty if download fails.
  }
}
