import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Category {
  final int? id;
  final String name;

  Category({
    this.id,
    required this.name,
  });

  factory Category.fromMap(Map<String, dynamic> json) => new Category(
    id: json['id'],
    name: json['name'],
  );

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'name': name,
    };
  }
}

class CategoryDatabase {
  CategoryDatabase._privateConstructor();
  static final CategoryDatabase instance = CategoryDatabase._privateConstructor();

  static Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'categories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE categories(
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL
      );
      ''');
  }

  Future<List<Category>> getCategories() async {
    Database db = await instance.database;
    var categories = await db.query('categories', orderBy: 'name');
    List<Category> categoryList = categories.isNotEmpty ? categories.map((c) => Category.fromMap(c)).toList()
        : [];
    return categoryList;
  }

  Future<Category?> fetchCategory(int? id) async {
    if (id == null) {
      return null;
    }
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM categories WHERE id=?', [id]);
    Category category = Category.fromMap(result[0]);
    return category;
  }

  Future<int> add(Category category) async {
    Database db = await instance.database;
    return await db.insert('categories', category.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Category category) async {
    Database db = await instance.database;
    return await db.update('categories', category.toMap(), where: 'id = ?', whereArgs: [category.id]);
  }
}

