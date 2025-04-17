import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalChatDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chatbot.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE faq (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question TEXT,
            answer TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertFaq(String question, String answer) async {
    final db = await database;
    await db.insert('faq', {'question': question, 'answer': answer});
  }

  static Future<String> getAnswer(String userInput) async {
    final db = await database;
    final List<Map<String, dynamic>> faqs = await db.query('faq');

    for (final faq in faqs) {
      if (userInput.toLowerCase().contains(faq['question'].toLowerCase())) {
        return faq['answer'];
      }
    }

    return "Sorry, I couldn't understand that. Try rephrasing.";
  }

  static Future<void> seedData() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM faq'))!;
    if (count == 0) {
      await insertFaq(
        'how to use urea',
        'Apply 40 kg/acre before irrigation during the early growth stage.',
      );
      await insertFaq(
        'what is npk',
        'NPK means Nitrogen, Phosphorus, and Potassium – essential nutrients.',
      );
      await insertFaq(
        'soil ph',
        'Use a soil pH meter. Ideal range is 6.0 to 7.5.',
      );
    }
  }
}
