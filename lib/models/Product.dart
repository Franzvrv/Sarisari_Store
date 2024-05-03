import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Product {
  final int? id;
  final String name;
  final int? category;
  int? stock;
  final double price;

  Product({
    this.id,
    required this.name,
    this.category,
    this.stock,
    required this.price,
  });

factory Product.fromMap(Map<String, dynamic> json) => new Product(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    stock: json['stock'],
    price: json['price'].toDouble(),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'stock': stock,
      'price': price,
    };
  }
}

class ProductDatabase {
  ProductDatabase._privateConstructor();
  static final ProductDatabase instance = ProductDatabase._privateConstructor();

  static Database ? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    print(db);
    await db.execute(
        '''CREATE TABLE products(
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      category INTEGER,
      stock INTEGER,
      price REAL);
      '''
    );
  }

  Future<List<Product>> getProducts() async {
    Database db = await instance.database;
    var products = await db.query('products', orderBy: 'name');
    List<Product> productList = products.isNotEmpty ? products.map((p) => Product.fromMap(p)).toList()
        : [];
    return productList;
  }

  void sellProduct(int? id, int amount) async {
    print(amount);
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM products WHERE id=?', [id]);
    Product product = Product.fromMap(result[0]);
    product.stock = product.stock! - amount;
    ProductDatabase.instance.update(product);
  }

  Future<int> add(Product product) async {
    Database db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Product product) async {
    Database db = await instance.database;
    return await db.update('products', product.toMap(), where: 'id = ?', whereArgs: [product.id]);
  }
}
